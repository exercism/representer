require "test_helper"

class PHPTest < RepresenterTest
  extend UpstreamTests

  track "php"

  # The old representer renamed every function, method and class that a
  # solution mentioned, even those that PHP provides or that another file
  # defines. This representer only renames what the solution defines.
  UNDEFINED = "This representer only renames a name that the solution defines. The old representer also renamed " \
              "classes and methods that the solution only uses (here MyClass and method), because it renamed " \
              "every one it saw.".freeze

  # PHP keeps variables and functions in separate namespaces. This
  # representer renames by name, so a variable and a function with the same
  # name get one placeholder and one entry in the mapping.
  SHARED_NAME = "This representer renames by name, so a variable and a function or method with the same name " \
                "share one placeholder and one entry in the mapping. The old representer gave each its own.".freeze

  # The upstream tests were written for the old representer's output, which
  # had no <?php tag. Each equivalent.php here is that output with a <?php
  # line added, so that it is a PHP file.
  DEVIATIONS = {
    "example-syntax-error" => {
      unrepresentable: true,
      why: "The solution has a syntax error, so it gets no representation."
    },
    "unit-function-case-insensitive-native" => {
      replace: { "function_exists" => "FunCtioN_ExiStS" },
      why: "PHP ignores the case of a function's name. The old representer wrote the name of a PHP function in " \
           "lower case. This representer has no list of PHP functions, so it leaves the case of a function the " \
           "solution doesn't define."
    },
    "unit-class-instantiation-backward-compatibility" => {
      restore: { "C0" => "MyClass", "m0" => "method" },
      remove: %w[MyClass method],
      why: UNDEFINED
    },
    "unit-function-aliases" => {
      remove: %w[array_key_exists count current floatval fwrite highlight_file implode ini_set is_float is_int is_writable rtrim
                 strstr],
      why: "This representer writes a function's aliases as its main name (join is implode, sizeof is count) without " \
           "listing them in the mapping, because they aren't names the student chose. The old representer listed them. " \
           "(The old mapping's stable names are real function names here, so the test helper reads the mapping the " \
           "other way round, and the names to remove are the stable ones.)"
    },
    "unit-function-name-as-expression" => {
      restore: { "fn0" => "a", "v0" => "a" },
      remove: ["a"],
      add: ["a"],
      why: SHARED_NAME
    },
    "unit-method-mapping" => {
      restore: { "m0" => "a", "v0" => "a" },
      remove: ["a"],
      add: ["a"],
      why: SHARED_NAME
    },
    "unit-method-expression" => {
      add: ["a"],
      why: "The old representer didn't rename ${a}. This representer reads ${a} as $a, which PHP does too."
    },
    "unit-string-simple-encapsulation" => {
      add: ["a"],
      why: "The old representer didn't rename a variable that was alone in a string (\"$a\"), which looks like an " \
           "oversight, because it renamed the same variable everywhere else. This representer renames it."
    }
  }.freeze

  upstream_tests ".php", deviations: DEVIATIONS

  # The old tests/example-multiple-files test has two solution files, and the
  # upstream_tests helper only handles one, so it is written out here. The
  # equivalent files are the old output with a <?php line added, except that
  # `use Helpers;` is `use C1;`, because this representer renames the class
  # there too and the old representer left it.
  def test_upstream_example_multiple_files
    input = {
      "Helpers.php" => "<?php\n\nclass Helpers\n{\n    public static function mod($x, $y)\n    {\n        return $x % $y;\n    }\n}\n",
      "Leap.php" => "<?php\n\nuse Helpers;\n\nclass Leap\n{\n    public static function isLeapYear($year)\n    {\n" \
                    "        return Helpers::mod($year, 4) === 0;\n    }\n}\n"
    }
    equivalent = {
      "Helpers.php" => "<?php\nclass C1\n{\n    public static function m1($v1, $v2)\n    {\n        return $v1 % $v2;\n    }\n}\n",
      "Leap.php" => "<?php\nuse C1;\nclass C0\n{\n    public static function m0($v0)\n    {\n" \
                    "        return C1::m1($v0, 4) === 0;\n    }\n}\n"
    }
    actual = Representer::RepresentSolution.("php", input, {})
    assert_equal actual.representation, Representer::RepresentSolution.("php", equivalent, {}).representation
    assert_equal %w[Helpers Leap isLeapYear mod x y year], actual.mapping.values.sort
  end

  def test_same_representation_as_the_old_assert_same_representation_tests
    # ClassTest: the type of a class constant doesn't matter.
    assert_same_representation(
      "<?php\ninterface I {\n    const string PHP = 'PHP 8.3';\n}\nclass Php84 implements I {\n    const string PHP = 'PHP 8.4';\n}",
      "<?php\ninterface I {\n    const PHP = 'PHP 8.3';\n}\nclass Php84 implements I {\n    const PHP = 'PHP 8.4';\n}"
    )
    # ClassInstantiationTest
    assert_same_representation "<?php\n(new MyClass())->method();", "<?php\nnew MyClass()->method();"
    # InlineHtmlTest
    assert_same_representation "\nThis is inline HTML.\n\n\n<?php\n\n$a = 1;\n\n?>\n\n\n<php\n\n\n?>\nAgain inline HTML.",
      "<?php\n$a = 1;"
    # StableSpacingTest
    assert_same_representation "<?php\n\nfunction helloWorld()\n{\n\n    return    \"Hello World!\"   ;\n}",
      "<?php\n\nfunction helloWorld()\n{\n    return \"Hello World!\";\n}"
    # ExitAndDieTest
    assert_same_representation "<?php\n\nexit(1);\nexit();", "<?php\n\ndie(1);\ndie();"
    # ArraySyntaxTest
    assert_same_representation "<?php\n\n$a = [0, 1, 'a' => 'b', 'c' => 'd'];", "<?php\n\n$a = array(0, 1, 'a' => 'b', 'c' => 'd');"
    assert_same_representation "<?php\n\n$a = [\n    0,\n    1,\n    'a' => 'b',\n    'c' => 'd',\n];",
      "<?php\n\n$a = [0, 1, 'a' => 'b', 'c' => 'd'];"
    # CastTest
    assert_same_representation "<?php\n$a = (double) 1.0;", "<?php\n$a = (float) 1.0;"
    assert_same_representation "<?php\n$a = (double) 1.0;", "<?php\n$a = (real) 1.0;"
    assert_same_representation "<?php\n$a = (boolean) true;", "<?php\n$a = (bool) true;"
    assert_same_representation "<?php\n$a = (integer) true;", "<?php\n$a = (int) true;"
    assert_same_representation "<?php\n$a = (binary) true;", "<?php\n$a = (string) true;"
  end

  def test_variable_mapping
    a = represent("<?php\nfunction helloWorld()\n{\n    $a = \"Hello World!\";\n    return $a;\n}")
    b = represent("<?php\nfunction helloWorld()\n{\n    $b = \"Hello World!\";\n    return $b;\n}")
    assert_equal a.representation, b.representation
    assert_equal %w[a helloWorld], a.mapping.values.sort
    assert_equal %w[b helloWorld], b.mapping.values.sort
  end

  # The old FunctionReorderingTest is skipped upstream ("not implemented yet"), and
  # the old ApplicationTest and ConsoleTest test its command line and the files it
  # reads, which this service doesn't have: the website sends the files in the request.

  def test_function_names_ignore_case
    assert_same_representation "<?php\nfunction Foo() { return 1; }\nFOO();", "<?php\nfunction bar() { return 1; }\nBar();"
    assert_same_representation "<?php\nclass Foo {}\n$a = new FOO;", "<?php\nclass Bar {}\n$a = new bar();"
  end

  def test_the_php_functions_a_solution_calls_stay_apart
    refute_same_representation "<?php\necho strtoupper('a');", "<?php\necho strtolower('a');"
    assert_same_representation "<?php\nclass A { function max() { return max($this->a); } }",
      "<?php\nclass A { function min() { return min($this->a); } }"
  end

  def test_visibility_is_ignored_but_static_is_not
    assert_same_representation "<?php\nclass A { private function f() {} }", "<?php\nclass A { final public function f() {} }"
    refute_same_representation "<?php\nclass A { static function f() {} }", "<?php\nclass A { function f() {} }"
    refute_same_representation "<?php\nclass A { private $x; }", "<?php\nclass A { public $x; }"
  end

  def test_properties_are_renamed_if_the_solution_defines_them
    assert_same_representation "<?php\nclass A { private $total = 0; function deposit($n) { $this->total += $n; } }",
      "<?php\nclass B { private $sum = 0; function put($m) { $this->sum += $m; } }"
    assert_same_representation "<?php\nclass A { function f($x) { return $x->name; } }",
      "<?php\nclass A { function f($y) { return $y->name; } }"
    refute_same_representation "<?php\nclass A { function f($x) { return $x->name; } }",
      "<?php\nclass A { function f($x) { return $x->title; } }"
  end

  def test_a_variable_named_like_a_function
    refute_same_representation "<?php\n$max = max($a);", "<?php\n$min = min($a);"
    assert_same_representation "<?php\n$count = count($a);", "<?php\n$total = count($b);"
  end

  def test_elseif_is_else_if_and_braces_are_optional
    assert_same_representation "<?php\nif ($a) { b(); } elseif ($c) { d(); } else { e(); }",
      "<?php\nif ($a) b(); else if ($c) d(); else e();"
    refute_same_representation "<?php\nif ($a) { b(); }", "<?php\nwhile ($a) { b(); }"
  end

  def test_numbers_are_their_values
    assert_same_representation "<?php\n$a = 1000 + 16 + 15;", "<?php\n$a = 1_000 + 0x10 + 017;"
    refute_same_representation "<?php\n$a = 1;", "<?php\n$a = 1.0;"
  end

  def test_strings
    assert_same_representation "<?php\n$a = 'it\\'s';", "<?php\n$a = \"it's\";"
    assert_same_representation "<?php\n$a = 'a\\\\b';", "<?php\n$a = \"a\\\\b\";"
    refute_same_representation "<?php\n$a = 'a\\nb';", "<?php\n$a = \"a\\nb\";"
    refute_same_representation "<?php\n$a = 'x';", "<?php\n$a = 'y';"
    refute_same_representation "<?php\n$a = \"\\xFF\";", "<?php\n$a = \"\\u{FF}\";"
  end

  def test_constants_and_keywords
    assert_same_representation "<?php\n$a = TRUE;", "<?php\n$a = true;"
    assert_same_representation "<?php\nclass A { const X = 1; function f() { return self::X; } }",
      "<?php\nclass B { const Y = 1; function g() { return self::Y; } }"
  end

  def test_names_in_the_tests_are_kept
    tests = { "LeapTest.php" => "<?php\nrequire 'Leap.php';\nclass LeapTest { function t() { isLeap(2000); } }" }
    result = represent("<?php\nfunction isLeap($year) { return $year % 4 == 0; }", filename: "Leap.php", exercise_files: tests)
    assert_equal ["year"], result.mapping.values
  end

  def test_syntax_errors_are_unrepresentable_with_the_php_version
    result = represent("<?php\nclass !")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::PHP.version, result.version
  end

  def test_an_empty_heredoc
    refute_same_representation "<?php\n$a = <<<EOT\nEOT;\n", "<?php\n$a = <<<EOT\nb\nEOT;\n"
  end

  # These semicolons and keywords are the only difference between each pair.
  def test_tokens_that_tell_programs_apart_are_kept
    refute_same_representation "<?php for (;; $i++) {}", "<?php for ($i++;;) {}"
    refute_same_representation "<?php for (; $i++;) {}", "<?php for ($i++;;) {}"
    refute_same_representation "<?php\nnamespace A;\nuse function B\\c;\necho c();", "<?php\nnamespace A;\nuse B\\c;\necho c();"
  end

  # From php-representer's mapping tests: PHP ignores the case of A to Z only.
  def test_only_ascii_letters_are_case_insensitive
    assert_equal ["AΛΕΙΤΟΥΡΓΙΑ"], represent("<?php\nfunction AΛΕΙΤΟΥΡΓΙΑ() {}\naΛΕΙΤΟΥΡΓΙΑ();\n").mapping.values
    assert_equal %w[AΤΑΞΗ], represent("<?php\nclass AΤΑΞΗ {}\nnew aΤΑΞΗ();\n").mapping.values
    assert_equal %w[A AΜΕΘΟΔΟΣ], represent("<?php\nclass A { public static function AΜΕΘΟΔΟΣ() {} }\nA::aΜΕΘΟΔΟΣ();\n").mapping.values
    refute_same_representation "<?php\nfunction ΛΕΙΤΟΥΡΓΙΑ() {}\nΛΕΙΤΟΥΡΓΙΑ();\n", "<?php\nfunction ΛΕΙΤΟΥΡΓΙΑ() {}\nλειτουργια();\n"
  end

  def test_use_and_includes_are_dropped
    assert_same_representation "<?php\nuse A\\B;\nrequire_once 'x.php';\ninclude 'y.php';\n$x = 1;", "<?php\n$x = 1;"
    assert_same_representation "<?php\nuse A\\B as C;\n$x = new C();", "<?php\nuse A\\B;\n$x = new B();"
    refute_same_representation "<?php\ndeclare(strict_types=1);\n$x = 1;", "<?php\n$x = 1;"
  end
end
