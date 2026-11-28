# Suggestions for Zig

These are changes to Zig's representation that could improve it, for the maintainers to discuss.
None of them is in Inspector yet.

- **`pub` before an import.** The grammar puts `pub` beside a declaration, outside it. If a solution has `pub const helper = @import("helper.zig");`, Inspector drops the import and leaves the `pub` on its own. Moving `pub` into the declaration after it, as Zig's own parser does, would drop the whole import.
- **Braces around a body.** `if (a) return b;` and `if (a) { return b; }` get different representations. Putting braces around every body of an `if`, `else`, `while` and `for` would give them one.
