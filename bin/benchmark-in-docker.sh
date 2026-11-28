#!/usr/bin/env bash

# Synopsis:
# Measure how the Docker image behaves under the Lambda runtime interface
# emulator: image size, start time, and the duration and memory of requests,
# including a worst case with a 200 KB solution and deeply nested code.
# Run it on a CI runner. It starts one container per scenario, so that each
# scenario gets its own cold first request.

# Output:
# Prints a table of results. If GITHUB_STEP_SUMMARY is set, also appends the
# table to it.

# Environment:
# SKIP_BUILD: skip building the image
# WARM_REQUESTS: how many requests to send after the first (default 5)

# Example:
# ./bin/benchmark-in-docker.sh

set -euo pipefail

warm_requests="${WARM_REQUESTS:-5}"
container_port=9876
url="http://localhost:${container_port}/2015-03-31/functions/function/invocations"
work_dir="$(mktemp -d)"
container_id=""

cleanup() {
    if [[ -n "${container_id}" ]]; then
        docker rm --force "${container_id}" > /dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

if [[ -z "${SKIP_BUILD:-}" ]]; then
    docker build --rm -t exercism/rosetta .
fi

# Image sizes
uncompressed_bytes=$(docker image inspect exercism/rosetta --format '{{.Size}}')
compressed_bytes=$(docker save exercism/rosetta | gzip | wc -c)
echo "${uncompressed_bytes} ${compressed_bytes}" > "${work_dir}/sizes.txt"
docker history --no-trunc=false --format '{{.Size}}\t{{.CreatedBy}}' exercism/rosetta > "${work_dir}/layers.txt" || true

# Scenarios: each one is "name<TAB>path to an event file"
scenarios_file="${work_dir}/scenarios.tsv"
: > "${scenarios_file}"

make_event() { jq -n --rawfile b "${1}" '{body: $b}' > "${2}"; }

# Realistic requests: one per language with a class, plus Basic (Haskell)
tracks=(clojure common-lisp cpp crystal csharp elixir elm fsharp gdscript gleam go java javascript nim php python ruby rust typescript wasm wren zig haskell)
for track in "${tracks[@]}"; do
    request=$(ls test/fixtures/requests/${track}/*/request.json | grep -v 'syntax-error' | head -n 1)
    name="${track}"
    [[ "${track}" == "haskell" ]] && name="basic (haskell)"
    make_event "${request}" "${work_dir}/event-${track}.json"
    printf '%s\t%s\n' "${name}" "${work_dir}/event-${track}.json" >> "${scenarios_file}"
done

# Worst cases: a 200 KB solution and deeply nested input
python3 - "${work_dir}" <<'PY'
import json, sys, glob

work = sys.argv[1]

methods = {
    "ruby": ("rb", "def method_{i}(a, b = 2)\n  # a comment\n  if a > b\n    result = a * b + {i}\n  else\n    result = [a, b].map {{ |x| x + 1 }}.sum\n  end\n  result\nend\n\n"),
    "javascript": ("js", "function method{i}(a, b = 2) {{\n  // a comment\n  let result;\n  if (a > b) {{\n    result = a * b + {i};\n  }} else {{\n    result = [a, b].map((x) => x + 1).reduce((s, x) => s + x, 0);\n  }}\n  return result;\n}}\n\n"),
    "csharp": ("cs", "    public static int Method{i}(int a, int b = 2)\n    {{\n        // a comment\n        int result;\n        if (a > b)\n        {{\n            result = a * b + {i};\n        }}\n        else\n        {{\n            result = new[] {{ a, b }}.Select(x => x + 1).Sum();\n        }}\n        return result;\n    }}\n\n"),
    "python": ("py", "def method_{i}(a, b=2):\n    # a comment\n    if a > b:\n        result = a * b + {i}\n    else:\n        result = sum([x + 1 for x in [a, b]])\n    return result\n\n\n"),
}
wrappers = {
    "csharp": ("using System.Linq;\n\npublic static class Big\n{\n", "}\n"),
}
nested = {
    "ruby": ("x = ", "1", "rb"),
    "javascript": ("const x = ", "1", "js"),
    "csharp": None,
    "python": ("x = ", "1", "py"),
}

def request(track, files):
    base = sorted(p for p in glob.glob(f"test/fixtures/requests/{track}/*/request.json") if "syntax-error" not in p)[0]
    req = json.load(open(base))
    req["solution_files"] = files
    return req

def write(name, req):
    body = json.dumps(req)
    open(f"{work}/body-{name}.json", "w").write(body)
    open(f"{work}/event-{name}.json", "w").write(json.dumps({"body": body}))
    with open(f"{work}/scenarios.tsv", "a") as f:
        f.write(f"{name}\t{work}/event-{name}.json\n")

for track, (ext, tmpl) in methods.items():
    head, tail = wrappers.get(track, ("", ""))
    for target, label in [(2_000, "2KB"), (10_000, "10KB"), (50_000, "50KB"), (100_000, "100KB"), (195_000, "200KB")]:
        parts, size, i = [head], len(head), 0
        while size < target:
            m = tmpl.format(i=i)
            parts.append(m)
            size += len(m)
            i += 1
        parts.append(tail)
        write(f"{track} {label}", request(track, {f"big.{ext}": "".join(parts)}))

for track, depth in [(t, d) for t in ["ruby", "javascript", "csharp", "python"] for d in (900, 3000)]:
    if track == "csharp":
        code = "class A { int x = " + "(" * depth + "1" + ")" * depth + "; }\n"
        ext = "cs"
    else:
        pre, core, ext = nested[track]
        code = pre + "(" * depth + core + ")" * depth + "\n"
    write(f"{track} nested {depth}", request(track, {f"nested.{ext}": code}))
PY

# Run each scenario in its own container
n=0
while IFS=$'\t' read -r name event; do
    n=$((n + 1))
    dir="${work_dir}/s${n}"
    mkdir -p "${dir}"
    echo "${name}" > "${dir}/name.txt"
    wc -c < "${event}" | tr -d ' ' > "${dir}/bytes.txt"

    echo "Running ${name}"
    started=$(date +%s.%N)
    container_id=$(docker run --detach --publish ${container_port}:8080 exercism/rosetta)

    # Send the real request until the container answers. The first successful
    # one is the cold request.
    ok=""
    for _ in $(seq 1 600); do
        if curl -s --max-time 120 -o "${dir}/first.json" -w '%{time_total}\n' -XPOST "${url}" --data-binary "@${event}" > "${dir}/first_time.txt" 2> /dev/null; then
            ok=1
            break
        fi
        sleep 0.1
    done
    ended=$(date +%s.%N)
    echo "${started} ${ended}" | awk '{printf "%.3f\n", $2 - $1}' > "${dir}/start.txt"
    jq -r '.statusCode // "error"' "${dir}/first.json" > "${dir}/status.txt" 2> /dev/null || echo "error" > "${dir}/status.txt"

    : > "${dir}/warm_times.txt"
    for _ in $(seq 1 "${warm_requests}"); do
        curl -s --max-time 120 -o /dev/null -w '%{time_total}\n' -XPOST "${url}" --data-binary "@${event}" >> "${dir}/warm_times.txt" || true
    done

    docker stats --no-stream --format '{{.MemUsage}}' "${container_id}" > "${dir}/stats.txt" || true
    docker logs "${container_id}" > "${dir}/logs.txt" 2>&1 || true
    docker rm --force "${container_id}" > /dev/null
    container_id=""
done < "${scenarios_file}"

# Summarise
python3 - "${work_dir}" <<'PY' | tee "${work_dir}/report.md"
import re, statistics, sys, glob, os

work = sys.argv[1]

def mb(n): return f"{int(n) / 1024 / 1024:.1f} MB"

unc, comp = open(f"{work}/sizes.txt").read().split()
out = ["## Rosetta image benchmark", "",
       f"- Image size, uncompressed: {mb(unc)}",
       f"- Image size, layers gzipped (about what ECR stores): {mb(comp)}", "",
       "Durations are in milliseconds. Cold is the first request to a new container. Warm is the median of the later requests (max in brackets).",
       "Wall times are measured by curl, so they include the HTTP round trip. Reported times come from the emulator's REPORT lines.",
       "Start is the time from `docker run` to the first successful response (it includes the cold request).", "",
       "| Scenario | Request KB | Start s | Cold ms | Warm ms | Reported cold ms | Reported warm ms | Billed warm ms | Max memory MB | Container mem | Status |",
       "|---|---|---|---|---|---|---|---|---|---|---|"]

def num(s): return float(s)
dirs = sorted(glob.glob(f"{work}/s*/"), key=lambda d: int(re.search(r"/s(\d+)/$", d).group(1)))
for d in dirs:
    r = lambda f: open(d + f).read().strip()
    first = num(r("first_time.txt")) * 1000 if os.path.getsize(d + "first_time.txt") else float("nan")
    warm = [num(x) * 1000 for x in r("warm_times.txt").split()]
    reports = [l for l in open(d + "logs.txt") if l.startswith("REPORT")]
    def field(l, k):
        m = re.search(k + r": ([\d.]+)", l)
        return float(m.group(1)) if m else None
    durs = [field(l, r"(?<!Billed )Duration") for l in reports]
    billed = [field(l, "Billed Duration") for l in reports]
    mems = [field(l, "Max Memory Used") for l in reports]
    def f(x): return "n/a" if x is None else f"{x:.0f}"
    wdurs = durs[1:]
    warm_s = f"{statistics.median(warm):.0f} ({max(warm):.0f})" if warm else "n/a"
    rcold = f(durs[0]) if durs else "n/a"
    rwarm = f(statistics.median(wdurs)) if wdurs else "n/a"
    bw = f(statistics.median(billed[1:])) if len(billed) > 1 else "n/a"
    mem = f(max(m for m in mems if m is not None)) if any(m is not None for m in mems) else "n/a"
    out.append(f"| {r('name.txt')} | {int(r('bytes.txt')) / 1000:.0f} | {r('start.txt')} | {first:.0f} | {warm_s} | {rcold} | {rwarm} | {bw} | {mem} | {r('stats.txt').split('/')[0].strip()} | {r('status.txt')} |")

out += ["", "Image layers:", "", "```"] + open(f"{work}/layers.txt").read().splitlines()[:30] + ["```"]
print("\n".join(out))
PY

if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    cat "${work_dir}/report.md" >> "${GITHUB_STEP_SUMMARY}"
fi
