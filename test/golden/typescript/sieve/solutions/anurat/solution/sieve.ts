export function primes(n: number): number[] {
    const p = [...Array(n + 1)].fill(true)
    p[0] = p[1] = false

    for (let i = 2; i <= Math.sqrt(n); i++) {
        if (!p[i]) continue

        for (let j = i * i; j <= n; j += i) {
            p[j] = false
        }
    }

    return p.map((bool, i) => bool ? i : 0)
        .filter(key => key)
}
