# How it works

This doc follows a solution through Rosetta, from the request to each output.
The representation takes the most steps, so it comes first, and the analysis and the snippet follow.
[common.md](./common.md) explains the language folders and the declarations mentioned here.

## The representation

For a language with a folder of its own, Rosetta:

1. Parses each file with the language's tree-sitter grammar. It skips files without one of the language's extensions, and test and config files, and turns Windows line endings into plain line breaks. If a file doesn't parse, the solution gets Basic's representation instead (see "Basic" below).
2. Drops what makes no difference to the solution working, such as comments, brackets that only group, and imports. Every solution that Rosetta sees passes its tests, so this code can't change what a mentor says about it.
3. Rewrites different spellings of the same code into one, such as Ruby's `x if y` into a block `if`, or `1_000` into `1000`.
4. Joins the files into one tree, in an order that depends only on their code. A file's name is never part of the representation, so renaming or reordering files doesn't change it.
5. Replaces every name the solution defines with a placeholder, wherever the name appears.
6. Writes the tree out as an indented s-expression.

Each language has a folder in [`lib/rosetta/languages/`](../lib/rosetta/languages/), such as [`ruby/`](../lib/rosetta/languages/ruby/).
In each folder, `common/spec.rb` says what the language is and how its files are read, including its comments and docstrings.
`representation/spec.rb`, `analysis/spec.rb` and `snippet/spec.rb` declare the settings of each output, such as the representation's version, names and imports.
The stages that describe steps 2 and 3 sit in `common/`, for the stages that every output needs, and `representation/`, for the stages that only the representation needs.
`transition.md` says how the language differs from the tools it replaces.
A comment above each declaration and method says what it does.
[CONTRIBUTING.md](../CONTRIBUTING.md) explains the stages and how to add a language.

## The engine's steps

The engine makes the decisions that apply to every language, and a language's stages run between its steps.
For every language, it does these things in order:

1. It ignores files without one of the language's extensions, and test and config files.
2. It turns Windows line endings into plain line breaks, then parses each file with the language's grammar. If a file doesn't parse, the solution gets Basic's representation instead (see "Basic" below).
3. It drops the comments declared in `common/spec.rb`, and runs the language's common stages (`GenerateAST`, then `Normalise`) on each file.
4. It drops the representation's imports from each file.
5. It runs the representation's `Normalise` stage on each file.
6. It renames every name defined by the solution, wherever the name appears: in its definition, and in every use, call and symbol. A name that the solution doesn't define keeps its name, such as a call to a library method. The engine never reads the exercise's tests or stub for names.
7. It joins the files into one tree, in an order set by their code, and leaves out the file names.
8. It runs the representation's `Reorder` stage on the joined tree.
9. It numbers the placeholders in the order the names appear, and writes the tree out as a nested, bracketed text form (an s-expression).

The snippet works on the grammar's own tree, before step 3.

## Basic

Every track that Rosetta has no language for gets Basic, which splits the code into tokens with the track's Rouge lexer, drops comments, spacing and some imports, and renames nothing.
Basic also represents a solution that its language's grammar can't parse, and its representation starts with a line that says `basic`.
[representation.md](./representation.md#basic) describes Basic in full.

## The analysis

Ruby also has an analysis, which gives the student comments on their solution.
It runs the stages in `common/` and the analysis's own `analysis/normalise.rb` on the main file, and then the rules of the exercise, one file per exercise in [`ruby/analysis/`](../lib/rosetta/languages/ruby/analysis/).
The analysis keeps the imports and the student's names, and doesn't reorder the code.
[analysis.md](./analysis.md) explains the rules.

## The snippet

Every track also gets a snippet: the first 15 lines of the solution's main file, without its comments or the boilerplate at its top, such as imports.
Each track's `snippet/spec.rb` in its folder in [`lib/rosetta/languages/`](../lib/rosetta/languages/) says what to leave out, and [snippets.md](./snippets.md) explains the rules.
For a language with a grammar, the snippet works on the grammar's tree, before any of the steps above change it.
