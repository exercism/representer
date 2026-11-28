# Emacs Lisp's transition

This file says how the Emacs Lisp outputs of this service differ from the tools they replace, and why.

## Representation

Emacs Lisp had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens.
The Emacs Lisp representer parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears, including quoted symbols such as the feature in `(provide 'two-fer)`. It renames the names of functions, macros, methods, global variables, aliases, errors, structures and classes with their slots and accessors, and every parameter and local variable (`let`, `let*`, `if-let`, `when-let*`, `dolist`, `dotimes`, `seq-let`, `cl-flet`, `cl-labels`, `cl-loop`, `condition-case` and the others).
- **Imports.** `require` forms are dropped. Basic kept them.
- **Forms.** Every form is the list that the Emacs Lisp reader gives, so `'x` and `(quote x)` are the same, and so are `#'f` and `(function f)`. `()` and `nil` are the same.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `"a\nb"` and a string with a real line break are the same. An escape it doesn't read keeps a node of its own.
- **Characters.** Each character is written as its value, so `?\(` and `?(` are the same, and so are `?\s` and `? `. A character stays apart from the number it reads as, so `?a` and `97` stay apart.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `1.` and `1` are the same, and so are `#x1F` and `31`, and `1e3` and `1000.0`. An integer stays apart from a float.
- **Layout.** Line breaks and spaces make no difference. Basic kept line breaks.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Emacs Lisp representer's version.

## Spellings that share a representation

The Emacs Lisp reader reads each of these pairs as the same program, so the representer gives them the same representation:

- Number spelling: `1.` → `1`, `+7` → `7`, `#x1F` → `31`, `#b11` → `3`, `#o17` → `15`, `#24r1k` → `44`, `1.50` → `1.5` and `1e3` → `1000.0`.
- An escape in a string and the text it stands for: `"a\nb"` → a string with a real line break, and `"a\` followed by a line break and `b"` → `"ab"`.
- Character spelling: `?\(` → `?(`, `?\x41` → `?A`, and `? ` → `?\s`.
- A quote mark and its list: `'x` → `(quote x)`, and `#'car` → `(function car)`.
- The empty list: `()` → `nil`.

## Analysis

This service doesn't make Emacs Lisp analyses yet, and Emacs Lisp has no old analyzer to compare with.

## Snippet

The snippet reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `require` forms at the top of the file, up to the first other form.
Before, the snippet applied the same rules to lines.
