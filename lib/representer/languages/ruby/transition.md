# Ruby's transition

This file says how the Ruby outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Ruby representer (`exercism/ruby-representer`).
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- The methods defined with `attr_reader`, `attr_writer` and `attr_accessor` keep their names. The old representer renamed them, but these are calls, and a call defines no name.
- Only the escapes used in the golden data are read (`\n`, `\t`, `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#`). The old representer read every escape, so it merged `"\x41"` and `"A"`, which stay apart here.
- `|a,|` and `|a|` stay apart, because `|a,|` takes an array's first element. The old representer merged them, which was a bug.

## Analysis

The analysis replaces the old Ruby analyzer (`exercism/ruby-analyzer`), for two-fer, leap, high-scores and acronym.
It gives the same comment keys and params, in the same cases, apart from these differences.
[`test/golden/ruby/ANALYSIS_DIFFERENCES.md`](../../../../test/golden/ruby/ANALYSIS_DIFFERENCES.md) compares the two on real solutions.

- Each comment has a type. The comments that say the tests will fail (`no_target_module`, `no_target_method` and `missing_default_param`) are essential. `string_interpolation`, `kernel_format`, `string_format` and acronym's `block_syntax.shorthand` are informative, and the others are actionable. The old analyzer gave no types, so the website showed every comment as informative.
- The analysis gives no status. The old analyzer approved, disapproved or referred each solution to a mentor, and the website no longer reads the status. An approval with no comment, such as acronym's three approved chains, gives no comment.
- Indentation with tabs is wrong. The old check only counted spaces, so it accepted any file indented with tabs, although the comment asks for two spaces and never tabs.
- A method "in one line" means a method with one statement. The old analyzer counted the lines of the method's body, so a statement split over two lines got no comment.
- A two-fer method with "you" as the default and a conditional in its one statement, such as a ternary, gets `incorrect_default_param`. The old analyzer crashed on these.
- High-scores' `initialize` must be exactly `@scores = scores`. The old analyzer only compared the first two lines of its source.
- The acronym and two-fer approved forms use the method's parameter. The old analyzer accepted any local variable, but a method of one statement has no other local.
- A solution with a syntax error gets the error `parse_error`. The old analyzer crashed, or for some invalid code accepted by its parser, gave its usual answer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `require` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `require` and `require_relative` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
