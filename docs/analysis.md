# Analysis

The analysis gives a student comments on their solution, in the analyzers' comment format.
Each exercise has its own rules, written as code patterns, and each rule says which comment to add when the solution matches it.
Only Ruby has an analysis so far, so every other track's `analysis` output gets the error `not_supported`.

This doc covers the `analysis` output, how the rules run and the verbs they use.
[common.md](./common.md) covers the language folder and `GenerateAST`, and [code-patterns.md](./code-patterns.md) covers code patterns. The analysis shares both with the other outputs.

## The `analysis` output

The `analysis` output holds the comments for the student, in the analyzers' comment format, and the analysis's version:

```json
{
  "analysis": {
    "comments": [
      { "comment": "ruby.two-fer.string_format", "params": { "name_variable": "name" }, "type": "informative" }
    ],
    "version": 1
  }
}
```

Each comment has a key, a type (`essential`, `actionable`, `informative` or `celebratory`), and `params` if its text has any.
The rules come from the exercise given in `exercise_slug`, and an exercise with no rules gets no comments.
The analysis reads the exercise's `.meta/config.json` from the request's `exercise_files`, to find the solution's main file.
This is the first file listed in `files.solution` that the student submitted, or else the student's first file.

If Inspector can't generate the analysis, the output holds an error with the shape described in the README's "Deployment" section, and `error` is one of these reasons:

- `not_supported`: the track has no analysis.
- `parse_error`: the solution's main file doesn't parse.
- `internal_error`: one of the analysis's rules raised an error.

## Versions

A language declares the analysis's `version` in `analysis/spec.rb`, and bumps it whenever the comments on any solution could change.
The analysis has its own version, so a change to it never makes the website represent the track's solutions again.

## How the rules run

The engine runs the common stages on the solution's main file, and then the analysis's own `Normalise` stage, in `analysis/normalise.rb`.
That stage only has to keep the code's meaning, such as Ruby's, which writes every way of defining a method on a class as `def self.name`.
It can use the same verbs as the representation's `Normalise` (see [representation.md](./representation.md#verbs-for-normalise)).
Before adding a rewrite to it, check that no rule needs the spelling it removes.
The analysis keeps the imports and the student's names, and doesn't reorder the code.

Each exercise has a file of rules in `analysis/`, named after its slug, such as `analysis/two_fer.rb` for two-fer:

```ruby
module Representer::Languages::Ruby::Analysis
  class Leap < Representer::Engine::AnalysisRules
    within ["class Year; {{...}}; end", "module Year; {{...}}; end"] do
      within "def self.leap?({{...}}); {{...}}; end" do
        uses(["Date.leap?({{...}})", "Date.gregorian_leap?({{...}})"]) { actionable "ruby.leap.std_lib" }
      end
    end
  end
end
```

Each rule starts with a condition written as code patterns (see [code-patterns.md](./code-patterns.md)), and its block says what to do when the condition holds.
A list of patterns means any of them.
The rules run in the order they are written, and the analysis returns every comment they add, in that order.
Each comment comes once, unless its params differ.
The block is plain Ruby, so it can hold more rules, which run only when its condition holds.
A one-line rule uses braces, so Ruby needs brackets around its patterns.
Give each exercise's rules a test file in `test/languages/<track>/`, such as `two_fer_analysis_test.rb`.

## The rules' verbs

- `uses(patterns)` runs its block if the code has a match. With `more_than: n`, it needs more than n matches, and a match inside another match doesn't count, so an `elsif` counts as part of its `if`.
- `uses_all(patterns)` runs its block if the code has a match of every pattern.
- `missing(patterns)` runs its block if the code has no match of any of them.
- `within(patterns)` runs its block once for each match, and the rules inside it only look inside that match. If nothing matches, the block doesn't run.
- `first_of` runs only the first rule inside it whose condition holds. A rule with no block stops the `first_of` without a comment.
- `essential`, `actionable`, `informative` and `celebratory` add a comment with its key and params, such as `actionable "ruby.two-fer.splat_args", name_variable: "{{name}}"`. A param that names a placeholder gives the code it matched.
- `indented_in_steps_of?(2)` says whether the main file is indented with spaces, in steps of two.

A word in a pattern must match the same code as the same word in a `within` around it, so `within "def self.two_fer({{name}} = {{default}}); {{...}}; end"` lets the rules inside it use the parameter as `{{name}}`.
A `{{_}}` or `{{...}}` never has to match another one.
Every pattern matches exactly (see [code-patterns.md](./code-patterns.md)), so `def self.two_fer({{name}} = "you"); {{_}}; end` matches a method with one optional parameter and one statement.
