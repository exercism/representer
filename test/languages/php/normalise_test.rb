require_relative "stage_helper"

# Tests PHP's two Normalise stages, which give one form to code that PHP
# reads the same way, and to code that works the same way.
class PHPNormaliseTest < Minitest::Test
  include PHPStages

  def test_drops_the_imports
    assert_same "<?php\nuse A\\B;\nuse function C\\d;\nrequire 'x.php';\nrequire_once 'x.php';\n" \
                "include 'y.php';\ninclude_once 'y.php';\n$x = 1;", "<?php\n$x = 1;"
    refute_same "<?php\ndeclare(strict_types=1);\n$x = 1;", "<?php\n$x = 1;"
  end

  def test_puts_the_bodies_of_ifs_and_loops_in_braces
    assert_same "<?php if ($a) b(); elseif ($c) d(); else e();", "<?php if ($a) { b(); } elseif ($c) { d(); } else { e(); }"
    assert_same "<?php if ($a) b(); else if ($c) d();", "<?php if ($a) { b(); } else { if ($c) { d(); } }"
    assert_same "<?php while ($a) b(); for (;;) b();", "<?php while ($a) { b(); } for (;;) { b(); }"
    assert_same "<?php foreach ($a as $x) b(); do b(); while ($a);", "<?php foreach ($a as $x) { b(); } do { b(); } while ($a);"
    refute_same "<?php if ($a) { b(); }", "<?php while ($a) { b(); }"
  end

  def test_an_elseif_stays_apart_from_an_else_if
    refute_same "<?php if ($a) { b(); } elseif ($c) { d(); }", "<?php if ($a) { b(); } else if ($c) { d(); }"
  end

  def test_drops_the_backslash_before_global_names
    assert_same "<?php $a = \\strlen($b) + \\Foo::bar(); $c = new \\DateTime();",
      "<?php $a = strlen($b) + Foo::bar(); $c = new DateTime();"
    refute_same "<?php $a = \\A\\strlen($b);", "<?php $a = strlen($b);"
  end

  def test_writes_each_name_that_ignores_case_in_one_case
    assert_same "<?php function Foo() {} FOO(); foo(); Foo();", "<?php function Foo() {} Foo(); Foo(); Foo();"
    assert_same "<?php class Foo { function Bar() {} } $a = new FOO(); $a->BAR();",
      "<?php class Foo { function Bar() {} } $a = new Foo(); $a->Bar();"
    assert_same "<?php $a = STRLEN($b) + StrLen($b);", "<?php $a = strlen($b) + strlen($b);"
    refute_same "<?php $a->Format();", "<?php $a->format();"
    refute_same "<?php $Foo = 1;", "<?php $foo = 1;"
  end

  def test_writes_each_alias_of_a_function_as_its_main_name
    assert_same "<?php $a = sizeof($b) + SizeOf($b, 1); $c = join(',', $d);",
      "<?php $a = count($b) + count($b, 1); $c = implode(',', $d);"
    refute_same "<?php $a = sizeof($b, 1);", "<?php $a = count($b);"
  end

  def test_every_method_is_public_and_not_final
    assert_same "<?php class A { private final function f() {} protected function g() {} }",
      "<?php class A { function f() {} public function g() {} }"
    refute_same "<?php class A { static function f() {} }", "<?php class A { function f() {} }"
    refute_same "<?php class A { private $x; }", "<?php class A { public $x; }"
  end

  def test_drops_the_type_of_each_class_constant
    assert_same "<?php class A { const string X = 'a'; }", "<?php class A { const X = 'a'; }"
  end

  def test_writes_each_string_with_code_as_a_concatenation
    assert_same "<?php $a = \"x $b {$c->d} y\";", "<?php $a = 'x ' . $b . ' ' . $c->d . ' y';"
    assert_same "<?php $a = \"$b\";", "<?php $a = $b;"
    assert_same "<?php $a = <<<EOT\nx $b\nEOT;\n", "<?php $a = 'x ' . $b;"
  end

  def test_joins_the_strings_in_each_concatenation
    assert_same "<?php $a = 'a' . 'b' . $c . 'd' . \"e\";", "<?php $a = 'ab' . $c . 'de';"
    assert_same "<?php $a = $b . ($c . $d);", "<?php $a = ($b . $c) . $d;"
    refute_same "<?php $a = $b . ($c + $d);", "<?php $a = ($b . $c) + $d;"
  end

  def test_keeps_the_case_of_constants
    refute_same "<?php $a = TRUE;", "<?php $a = true;"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
