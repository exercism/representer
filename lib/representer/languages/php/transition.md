# PHP's transition

This file says how the PHP outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old PHP representer (`exercism/php-representer`), which renamed names in nikic/php-parser's tree and printed the tree back as code.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- A solution with a syntax error gets Basic's representation, which only drops comments and formatting. The old representer gave it the solution's code unchanged. A file that has no `<?php` tag, and so holds no PHP code, gets Basic's representation too.
- The old representer renamed every variable, including `$this` and the superglobals such as `$_GET`. This representer renames each variable that the solution sets: by assignment, as a parameter, in a loop, `catch`, `global`, `static` or a closure's `use`, or by passing it to a function. `$this` and the superglobals keep their names. A variable that is only ever read keeps its name too, which only happens in code that would warn when it runs.
- The mapping writes each variable with its `$`, as in `$year`, so that a variable and a function with the same name stay two names.
- PHP ignores the case of function, method and class names. The old representer gave every spelling of such a name one placeholder, across all the files, and wrote PHP's own functions in lower case. This representer does the same within each file: a name defined in the file gets the spelling it has most often, and a function that the file doesn't define gets lower case. So in a solution with several files, a function defined in one file and called from another will get its placeholder at the call only if its name is all lower case. A method or class that the solution doesn't define keeps its spelling, so `$date->Format()` and `$date->format()` stay apart. No golden solution is affected by either.
- Each number is written as its value, so `0x10` and `16` are the same. The old representer kept the base a number was written in.
- An escape for a byte above 127, such as `"\xFF"`, keeps its text. The old representer read it as a byte, so it merged `"\xFF"` and `"\377"`.

## Spellings that share a representation

PHP's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `'you'` → `"you"`, and `'it\'s'` → `"it's"`.
- A heredoc or nowdoc and the same string in quotes: `<<<END` with the line `you` → `"you"`, and `<<<'END'` with the line `you` → `'you'`.
- An escape and the character it stands for: `"\x41"` → `"A"`, `"\101"` → `"A"` and `"\u{41}"` → `"A"`.
- Braces around a variable in a string: `"a${a}"` → `"a$a"`, and `"a{$a}"` → `"a$a"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `017` → `15`, `0o17` → `15`, `0b101` → `5`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `($a * $b) + $c` → `$a * $b + $c`.
- The two ways to write an array: `array(1, 2)` → `[1, 2]`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, and `g($a, $b,)` → `g($a, $b)`.
- An empty statement: `return 1;;` → `return 1;`.
- Braces around the body of `if`, `else` and loops: `if ($a) return 1;` → `if ($a) { return 1; }`.
- A `\` before a global function or class name: `\strlen($a)` → `strlen($a)`, and `new \DateTime()` → `new DateTime()`.
- Empty brackets after `new`: `new DateTime` → `new DateTime()`.
- The case of a function name: `STRLEN($a)` → `strlen($a)`.
- The ways to end the program: `exit;` → `exit();`, and `die("x");` → `exit("x");`.
- The other names of a cast: `(integer)` → `(int)`, `(boolean)` → `(bool)` and `(DOUBLE)` → `(float)`.

The representer also gives the same representation to some code that PHP's parser reads differently, because the code works the same way: a function alias and its main name (`sizeof($a)` → `count($a)`), a method's visibility and `final` (`private function g()` → `public function g()`), and a string with code in it and the matching concatenation (`"a $a"` → `'a ' . $a`).

## Analysis

This service doesn't make PHP analyses yet, so there is nothing to compare with the old analyzer (`exercism/php-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, the opening tag and the declarations at the top by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `<?php` tag, `declare`, `namespace` and `use` statements at the top of the file, up to the first other statement.
For a namespace written with braces, it skips only the header line and shows the code inside.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
