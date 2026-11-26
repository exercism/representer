sub transform (%input) is export {
    Hash[Int:D, Str:D].new:
        %input.map: { .value>>.uc X .key }
}