# Ruby analysis differences

This file compares the comments of Ruby's analysis with the comments of the analyzer it replaces, on the same solutions.
Two solutions agree when they get the same comment keys with the same params.
The old analyzer gives no comment types, so the comparison ignores them.

## The solutions

The comparison used 892 solutions:

- The golden solutions in this folder for the four exercises with rules (15 solutions).
- The solutions in the old analyzer's own fixtures and unit tests (77 solutions).
- The top 200 published community solutions of each of the four exercises, downloaded on 2026-11-27 (800 solutions).

The old analyzer ran from its source, one solution at a time, under Ruby 4.0 with its own gems.

## Agreement

| Exercise | Golden | Old analyzer's tests | Community | All | Old analyzer crashed |
|---|---|---|---|---|---|
| two-fer | 3/4 | 50/50 | 194/200 | 247/254 | 4 |
| leap | 4/4 | 4/4 | 200/200 | 208/208 | 0 |
| high-scores | 4/4 | 5/5 | 197/200 | 206/209 | 3 |
| acronym | 3/3 | 16/18 | 194/200 | 213/221 | 6 |

The old analyzer commented on 207 of the 254 two-fer solutions, 5 leap solutions, 3 high-scores solutions and 4 acronym solutions.
It gives no comment when it approves an acronym or high-scores solution, so most of those solutions agree with no comments on either side.

## The disagreements

### Tabs count as wrong indentation

The new analysis gives `ruby.general.incorrect_indentation` in place of the old comment for three two-fer solutions indented with tabs (golden `neilnorthrop`, community `mertalpaslan` and `jutley`).
The old check only counted spaces, so it read every tab-indented line as not indented.
The comment asks for two spaces and never tabs, so the new check counts a tab as wrong indentation.

### The old analyzer crashed

The old analyzer raised an error on 13 solutions. The new analysis gives them no comment, apart from one:

- Two-fer `dhoangk07`, `joemecha` and `rafa2000` test the parameter with `||` or `or`, such as `if name.nil? || name.empty?`. The new analysis leaves them to a mentor, as it does any conditional that it doesn't recognise.
- Two-fer `Lucyna` is a one-line ternary on the parameter, with "you" as the default. The new analysis gives `ruby.two-fer.incorrect_default_param`, as it does for any conditional on the parameter.
- High-scores `jhass`, `wvmitchell` and `yilinng` have no class body with several members, such as `HighScores = Struct.new(:scores)`.
- Acronym `kotp`, `zredcay`, `codeholic`, `thelmalu`, `TravisSpangle` and `onemanstartup` define `abbreviate` in a way the old analyzer didn't find, such as after `extend self`.

### Code that isn't valid Ruby

One of the old analyzer's acronym fixtures, used both as a fixture and in a unit test, has the body `anything_here.123.456.test_method`.
The old parser accepted it, and the new analysis reports a `parse_error`.
