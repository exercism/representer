# Vimscript's transition

This file says how the Vimscript outputs of this service differ from the tools they replace, and why.

## Representation

Vimscript had no representer of its own, so the track used Basic, which drops comments and the spaces between tokens and keeps everything else as it is written, including line breaks.
The representation now parses the solution with tree-sitter-vim and writes the tree that Vim's own parser would read.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Vimscript, these are the changes:

- **Names.** Basic kept every name. Every function, parameter and variable the solution defines now gets a placeholder wherever its name appears, and so does every dictionary member that the solution assigns to or defines a function on, such as `self.count` and `s:stack.Push`. Vim's own variables, such as `v:val`, keep their names.
- **Scopes.** Vim gives a name with no scope a scope of its own, so Rosetta drops the scope where it is the one Vim would give anyway: `l:` inside a function, `g:` outside functions, and `g:` on the name of a function that is defined or called. `l:count` and the other names that Vim keeps for its own variables (`count`, `errmsg`, `shell_error`, `this_session` and `version`) keep their `l:`. Every other scope stays, so `s:x`, `a:x` and `x` stay apart.
- **Layout.** Comments, line breaks, line continuations, `|` between commands, abbreviated commands (such as `fun` and `endf`) and brackets that only group make no difference.
- **Strings and numbers.** Each string is written as its value, so `'it''s'` and `"it's"` are the same. Each number is written as its value, so `0x1F`, `037` and `31` are the same, and `1.5e3` and `1500.0` are the same. `1` and `1.0` stay apart, because Vim reads one as a number and the other as a float.
- **Concatenation.** Vim reads `.` and `..` as the same operator, so `a . b` and `a .. b` are the same, and so are `.=` and `..=`. The grammar reads a dot with spaces around it as a dictionary member, and Rosetta reads it as concatenation, as Vim does. A dot with no spaces (`d.key`) stays a member.
- **Imports.** Rosetta drops `source` and `runtime`, as imports.
- **Vim9 script.** The grammar reads Vim9 script's declarations and types as plain words, so a file that starts with `vim9script` or defines a function with `def` still gets Basic's representation, with Vimscript's version. Five of the 124 golden solutions are Vim9 script.
- **Errors.** A solution with a syntax error still gets Basic's representation, with Vimscript's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Vimscript solution again.

## Spellings that share a representation

Vim's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `'you'` → `"you"`, and `'it''s'` → `"it's"`.
- An escape in a double-quoted string and the character it stands for: `"a\tb"` → a string with a tab, and `"say \"hi\""` → `'say "hi"'`.
- Number spelling: `0x1F` → `31`, `0b11` → `3`, `017` → `15` and `1.5e3` → `1500.0`.
- A sign written on a number and the same sign as an operator: `-1` → `- 1`.
- Brackets that only group: `(a && b) || c` → `a && b || c`.
- Concatenation with one dot or two: `a . b` → `a .. b`, and `let s .= t` → `let s ..= t`.
- An abbreviated command: `fun! F()` → `function! F()`, `retu x` → `return x` and `endf` → `endfunction`.
- Commands on one line: `if x | return 1 | endif` → `if x`, `return 1` and `endif` on three lines.
- A literal dictionary: `#{name: 1}` → `{'name': 1}`.
- The local scope inside a function: `let l:total = 0` → `let total = 0`.
- The global scope outside functions: `let g:limit = 10` → `let limit = 10`.
- The global scope on a function's name: `function! g:Response()` → `function! Response()`, and `call g:Response()` → `call Response()`.

## Analysis

This service doesn't make Vimscript analyses yet, and Vimscript had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to come from Basic's snippet, which removes the comments found by Rouge's Vimscript lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips `scriptencoding` and `vim9script` at the top of the file, up to the first other statement.
Its version is now 2.
