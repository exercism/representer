require "test_helper"

class ElmTest < RepresenterTest
  extend UpstreamTests

  track "elm"

  # The upstream tests are elm-test unit tests, each with a snippet of code and
  # the output it must contain. Each is a fixture here: the snippet below the
  # module line that the old tests added, and the expected output (made valid
  # Elm, which the old tests' whitespace-stripped strings weren't) as the
  # equivalent. A test's name says which upstream suite it came from.

  UNDEFINED = "The old representer renamed every name that wasn't a standard library name, including %s, which " \
              "the solution never defines. This representer only renames names the solution defines, so %s keeps " \
              "its name.".freeze

  def self.undefined(placeholder, name, what)
    { restore: { placeholder => name }, remove: [name], why: format(UNDEFINED, what, name) }
  end

  DEVIATIONS = {
    "expression-record-access" => undefined("identifier_3", "y", "a field read from a record"),
    "expression-record-access-function" => undefined("identifier_3", "y", "a field read from a record"),
    "expression-record" => undefined("identifier_3", "firstName", "a value from elsewhere"),
    "destructuring" => undefined("identifier_3", "person", "a value from elsewhere"),
    "type-alias-custom-type" => undefined("Identifier_2", "Name", "a type from elsewhere"),
    "type-alias-generic-parameter" => undefined("Identifier_3", "AnotherCustomType", "a type from elsewhere"),
    "type-alias-tuple-of-custom-types" => undefined("Identifier_2", "Name", "a type from elsewhere"),
    "type-alias-function" => undefined("Identifier_2", "Name", "a type from elsewhere"),
    "type-alias-record" => undefined("Identifier_3", "Name", "a type from elsewhere"),
    "pattern-uncons" => {
      unrepresentable: true,
      why: "`f x :: xs = ...` isn't valid Elm. The old parser accepted it, but tree-sitter rejects it, so this " \
           "representer gives it no representation."
    }
  }.freeze

  upstream_tests ".elm", deviations: DEVIATIONS

  # The upstream tests for the names that Elm imports into every module. A
  # solution that defines one of these keeps its name.
  %w[toFloat round floor ceiling truncate max min compare not xor modBy remainderBy negate abs clamp sqrt logBase e pi
     cos sin tan acos asin atan atan2 degrees radians turns toPolar fromPolar isNaN isInfinite identity always never
     number comparable appendable compappend].each do |word|
    define_method("test_upstream_a_function_called_#{word}_keeps_its_name") do
      refute_same_representation "#{word} x =\n    x", "zzz x =\n    x"
    end
  end

  %w[Int Float Order GT EQ LT Bool True False Never List Maybe Just Result Ok Err String Char Tuple Debug Program Cmd
     Sub].each do |word|
    define_method("test_upstream_a_type_called_#{word}_keeps_its_name") do
      refute_same_representation "type #{word} = Zzz", "type Yyy = Zzz"
    end
  end

  def test_names_are_renamed_by_kind
    assert_same_representation "x =\n    1", "y =\n    1"
    refute_same_representation "type X = A", "type X = A Int"
  end

  def wrap(body) = "module M exposing (f)\n\n#{body}\n"

  def test_comments_are_dropped
    assert_same_representation wrap("f x =\n    x"), wrap("-- a\n{- b -}\nf x =\n    -- c\n    x")
  end

  def test_brackets_stay
    assert_same_representation wrap("f x =\n    g (h x)"), wrap("f x =\n    g   (h  x)")
    refute_same_representation wrap("f x =\n    (x)"), wrap("f x =\n    x")
    refute_same_representation wrap("f x =\n    g (h x)"), wrap("f x =\n    g h x")
    refute_same_representation wrap("f a b c =\n    (a + b) * c"), wrap("f a b c =\n    a + b * c")
  end

  def test_strings_are_their_values
    assert_same_representation wrap("f =\n    \"a\\u{41}\""), wrap("f =\n    \"aA\"")
    assert_same_representation wrap("f =\n    \"\"\"a\"\"\""), wrap("f =\n    \"a\"")
    refute_same_representation wrap("f =\n    \"a\""), wrap("f =\n    \"b\"")
    refute_same_representation wrap("f =\n    \"a\\qb\""), wrap("f =\n    \"aqb\"")
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation wrap("f a =\n    let\n        b = a\n    in\n    b"),
      wrap("f x =\n    let\n        y = x\n    in\n    y")
    refute_same_representation wrap("f a b =\n    a"), wrap("f a b =\n    b")
  end

  def test_fields_are_renamed_through_dots
    code = "type alias R =\n    { %s : Int }\n\nf r =\n    r.%s\n\ng =\n    { %s = 1 }"
    assert_same_representation wrap(format(code, "a", "a", "a")), wrap(format(code, "b", "b", "b"))
  end

  def test_constructors_are_renamed_where_they_are_used
    code = "type T\n    = %s\n\nf =\n    %s"
    assert_same_representation wrap(format(code, "A", "A")), wrap(format(code, "B", "B"))
  end

  def test_names_after_a_module_dot_keep_their_names
    refute_same_representation wrap("f xs =\n    List.map xs"), wrap("f xs =\n    List.filter xs")
    refute_same_representation wrap("map xs =\n    List.map xs"), wrap("map xs =\n    List.filter xs")
  end

  def test_exposed_names_are_kept
    refute_same_representation "module M exposing (f)\n\nf x =\n    x\n", "module M exposing (g)\n\ng x =\n    x\n"
  end

  def test_names_the_tests_use_are_kept
    refute_same_representation wrap("f x =\n    x"), wrap("g x =\n    x"),
      exercise_files: { "tests/Tests.elm" => "module Tests exposing (..)\n\nt =\n    f 1\n" }
  end

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "module M exposing (..)\n\nf =\n"
  end
end
