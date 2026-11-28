# Suggestions for Uiua

These are improvements to Uiua's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **Names run together.** Uiua's formatter splits a run of primitive names written without spaces, so `revrev` becomes `⇌⇌` and `kbn` becomes `▽⊸≠`. The grammar reads such a run as one word, and Inspector keeps it as it is written, so `revrev` and `⇌⇌` stay apart. None of the golden solutions writes names this way.
- **Names from older versions of Uiua.** Inspector reads primitive names as the current version of Uiua does. A deprecated name, such as `each` (`∵`), `duplicate` (`.`) or `flip` (`:`), keeps its text, so `each` and `∵` stay apart. Some solutions were written for older versions of Uiua, which read some names differently. None of the golden solutions uses a deprecated name.
- **ASCII comparisons.** The grammar reads `!=`, `<=` and `>=` as primitives. The current version of Uiua has no such spellings, so Inspector keeps them apart from `≠`, `≤` and `≥`. Older versions may have read them as those glyphs.
- **A binding's body in brackets.** `F ← (+1)` and `F ← +1` define the same function, but Inspector keeps the brackets, because Uiua's parser reads them as an inline function. A mentor would probably give both the same feedback.
- **Signatures.** Inspector keeps a signature as it is written, so `|2` and `|2.1` stay apart, although Uiua reads a signature with no outputs as having one.
- **Labels.** A label such as `$Count` only tags a value for debugging. Inspector keeps it, so two solutions that differ only in a label stay apart.
- **Fractions.** Inspector keeps a fraction such as `1/2` as it is written, so `1/2` and `0.5` stay apart, although Uiua reads them as the same number.
