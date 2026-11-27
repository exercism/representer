require "test_helper"

class PHPTest < RepresenterTest
  extend UpstreamTests

  track "php"

  UNDEFINED = "This representer only renames a name that the solution defines. The old representer also renamed " \
              "classes and methods that the solution only uses (here MyClass and method), because it renamed " \
              "every one it saw.".freeze

  DOLLARS = "This representer keeps a variable's `$` in the mapping, as in `$year`, because PHP keeps variables " \
            "apart from functions and methods with the same name.".freeze

  UNSET = "The variable is never set, so the solution doesn't define it and this representer keeps its name. The " \
          "old representer renamed every variable.".freeze

  # The deviation for a test whose variables are set, so the mapping lists
  # each of them with its `$`.
  def self.with_dollars(*names) = { remove: names, add: names.map { |name| "$#{name}" }, why: DOLLARS }

  # The deviation for a test that reads a variable it never sets, written as
  # $v0 in the equivalent file.
  def self.unset(name) = { restore: { "v0" => name }, remove: [name], why: UNSET }

  # The upstream tests were written for the old representer's output, which
  # had no <?php tag. Each equivalent.php here is that output with a <?php
  # line added, so that it is a PHP file.
  DEVIATIONS = {
    "example-syntax-error" => {
      parse_error: true,
      why: "The solution has a syntax error, so it gets Basic's representation."
    },
    "example-leading-trailing-empty-lines" => with_dollars("year"),
    "example-single-file" => with_dollars("year"),
    "example-trailing-whitespace" => with_dollars("year"),
    "unit-class-anonymous" => with_dollars("a"),
    "unit-class-mapping" => with_dollars("a"),
    "unit-function-name-as-expression" => { remove: ["a"], add: ["a", "$a"], why: DOLLARS },
    "unit-class-instantiation-backward-compatibility" => {
      restore: { "C0" => "MyClass", "m0" => "method" },
      remove: %w[MyClass method],
      why: UNDEFINED
    },
    "unit-function-aliases" => {
      remove: %w[array_key_exists count current floatval fwrite highlight_file implode ini_set
                 is_float is_int is_writable rtrim strstr],
      why: "This representer writes a function's aliases as its main name (join is implode, sizeof is count) without " \
           "listing them in the mapping, because they aren't names the student chose. The old representer listed them. " \
           "(The old mapping's stable names are real function names here, so the test helper reads the mapping the " \
           "other way round, and the names to remove are the stable ones.)"
    },
    "unit-method-mapping" => { restore: { "v0" => "a" }, remove: ["a"], add: ["a"], why: UNSET },
    "unit-string-encapsulation" => unset("a"),
    "unit-string-heredoc-with-escapes" => unset("a"),
    "unit-string-useless-interpolated-concatenation-left-left" => unset("c"),
    "unit-string-useless-interpolated-concatenation-left-left-and-right-right" => unset("c"),
    "unit-string-useless-interpolated-concatenation-left-right" => unset("c"),
    "unit-string-useless-interpolated-concatenation-right-left" => unset("c"),
    "unit-string-useless-interpolated-concatenation-right-right" => unset("c")
  }.freeze

  upstream_tests ".php", deviations: DEVIATIONS

  # The old tests/example-multiple-files test has two solution files, and the
  # upstream_tests helper only handles one, so it is written out here. The
  # equivalent files are the old output with a <?php line added, and without
  # the `use Helpers;`, which this representer drops as an import.
  def test_upstream_example_multiple_files
    input = {
      "Helpers.php" => "<?php\n\nclass Helpers\n{\n    public static function mod($x, $y)\n    {\n        return $x % $y;\n    }\n}\n",
      "Leap.php" => "<?php\n\nuse Helpers;\n\nclass Leap\n{\n    public static function isLeapYear($year)\n    {\n" \
                    "        return Helpers::mod($year, 4) === 0;\n    }\n}\n"
    }
    equivalent = {
      "Helpers.php" => "<?php\nclass C1\n{\n    public static function m1($v1, $v2)\n    {\n        return $v1 % $v2;\n    }\n}\n",
      "Leap.php" => "<?php\nclass C0\n{\n    public static function m0($v0)\n    {\n" \
                    "        return C1::m1($v0, 4) === 0;\n    }\n}\n"
    }
    actual = Representer::RepresentSolution.("php", input)
    assert_equal actual.representation, Representer::RepresentSolution.("php", equivalent).representation
    assert_equal ["$x", "$y", "$year", "Helpers", "Leap", "isLeapYear", "mod"], actual.mapping.values.sort
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
    assert_equal ["$a", "helloWorld"], a.mapping.values.sort
    assert_equal ["$b", "helloWorld"], b.mapping.values.sort
  end

  # The old FunctionReorderingTest is skipped upstream ("not implemented yet"), and
  # the old ApplicationTest and ConsoleTest test its command line and the files it
  # reads, which this service doesn't have: the website sends the files in the request.

  def test_the_php_functions_a_solution_calls_stay_apart
    refute_same_representation "<?php\necho strtoupper('a');", "<?php\necho strtolower('a');"
    assert_same_representation "<?php\nclass A { function max() { return max($this->a); } }",
      "<?php\nclass A { function min() { return min($this->a); } }"
  end

  def test_a_variable_named_like_a_function
    assert_same_representation "<?php\nfunction f($a) { $max = max($a); }", "<?php\nfunction f($b) { $min = max($b); }"
    refute_same_representation "<?php\nfunction f($a) { $max = max($a); }", "<?php\nfunction f($a) { $max = min($a); }"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_php_version
    assert_basic_representation "<?php\nclass !"
  end

  def test_a_file_with_no_php_code_gets_a_basic_representation
    assert_basic_representation "<h1>Hello</h1>"
  end

  def test_imports_are_dropped
    assert_same_representation "<?php\nuse A\\B;\nrequire_once 'x.php';\ninclude 'y.php';\n$x = 1;", "<?php\n$x = 1;"
    refute_same_representation "<?php\ndeclare(strict_types=1);\n$x = 1;", "<?php\n$x = 1;"
  end

  # PHP ignores the case of A to Z only.
  def test_only_ascii_letters_are_case_insensitive
    assert_equal ["AΛΕΙΤΟΥΡΓΙΑ"], represent("<?php\nfunction AΛΕΙΤΟΥΡΓΙΑ() {}\naΛΕΙΤΟΥΡΓΙΑ();\n").mapping.values
    assert_equal ["AΤΑΞΗ"], represent("<?php\nclass AΤΑΞΗ {}\nnew aΤΑΞΗ();\n").mapping.values
    method = "<?php\nclass A { public static function AΜΕΘΟΔΟΣ() {} }\nA::aΜΕΘΟΔΟΣ();\n"
    assert_equal %w[A AΜΕΘΟΔΟΣ], represent(method).mapping.values
    refute_same_representation "<?php\nfunction ΛΕΙΤΟΥΡΓΙΑ() {}\nΛΕΙΤΟΥΡΓΙΑ();\n", "<?php\nfunction ΛΕΙΤΟΥΡΓΙΑ() {}\nλειτουργια();\n"
  end
end
