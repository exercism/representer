# Suggestions for Ballerina

These are improvements to Ballerina's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **Names after a generic or optional type.** GenerateAST finds a variable from the token before its name, which must be a type keyword, a name or `]`. So Inspector keeps the names in `map<int> counts = {};` and `int? best = ();`, and two solutions that only name those variables differently stay apart.
- **Integers.** The grammar reads `0x1F` as `0` and the name `x1F`, and Inspector writes every integer as it is written. Writing each integer as its value would make `0x1F` and `31` the same.
- **Templates and strings.** `` string `a` `` and `"a"` are the same string, and stay apart.
