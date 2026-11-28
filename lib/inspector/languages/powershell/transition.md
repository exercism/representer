# PowerShell's transition

This file says how the PowerShell outputs of this service differ from the tools they replace, and why.

## Representation

PowerShell had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-powershell instead, and writes the tree that PowerShell's own parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: functions and the commands that call them, parameters and the command parameters that pass them (`-Year`), variables assigned to or used in `foreach`, classes, their properties and methods, and enums and their members. A variable with a scope, such as `$global:total`, is renamed as one name with its scope.
- **Case.** PowerShell ignores the case of names and keywords, so Inspector writes them in lower case. `Return $Year.Length` and `return $year.length` are the same, and so are `[INT]` and `[int]`, and `Write-Host` and `write-host`. Strings, bare words passed to a command and hash keys keep their case.
- **Layout.** Basic kept line breaks. Inspector drops comments, layout, backtick line continuations, semicolons, pipes and brackets that only group, so `($a * $b) / $c` and `$a * $b / $c` are the same. Brackets around a command or an assignment stay, because `(Get-Date).Year` needs them and `($x = 1)` writes out its value.
- **Imports.** The `using namespace`, `using module` and `using assembly` statements are dropped, as imports.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `'it''s'`, `"it's"` and a here-string holding `it's` are the same. A bare word passed to a command, as in `Write-Host hello`, and a bare hash key, as in `@{ a = 1 }`, are strings too. A string that holds variables or `$(...)` keeps them, with the text between them written as values.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `1.50` and `1.5` are the same, and so are `1e3` and `1000.0`, and `0x1F` and `31`. An integer, a double and a decimal (`1.5d`) stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with PowerShell's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

PowerShell's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- The case of keywords, operators and names: `IF ($X -EQ 1) { RETURN $X }` → `if ($x -eq 1) { return $x }`.
- Braces around a variable's name: `${count}` → `$count`.
- Quote style: `'it''s'` → `"it's"`, `"say ""hi"""` → `'say "hi"'`, and `@'` here-strings → `'...'`.
- A bare word as a string: `Write-Host hello` → `Write-Host 'hello'`, and `@{ a = 1 }` → `@{ 'a' = 1 }`.
- Number spelling: `1.50` → `1.5`, `1e3` → `1000.0`, `0x1F` → `31` and `10L` → `10l`.
- Empty brackets after a function's name: `function f() { }` → `function f { }`.
- Brackets that only group: `($a * $b) / $c` → `$a * $b / $c`.
- A `;` after a statement, and a backtick that continues a line: `$x = 1;` → `$x = 1`.

## Analysis

This service doesn't make PowerShell analyses yet, and PowerShell had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `using` statements at the top of the file, up to the first other statement.
Its version is now 2.
