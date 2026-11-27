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

  QUALIFIED = "The solution defines `length`, so this representer renames it wherever it appears, including in " \
              "`%s.length`. The old representer kept a name after a module's dot.".freeze

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
    "imports-qualified" => { replace: { "Dict.length" => "Dict.identifier_1" }, why: format(QUALIFIED, "Dict") },
    "imports-qualified-aliased" => { replace: { "D.length" => "D.identifier_1" }, why: format(QUALIFIED, "D") },
    "exports-module-name" => {
      merges_with: "exports-exposed-things",
      why: "The two tests only differ in what the module exposes. This representer drops the exposing list, as " \
           "every solution exposes what the tests use."
    },
    "expression-parenthesized" => {
      merges_with: "function-name-and-parameters",
      why: "`(x)` and `x` are the same value. The old representer kept brackets that only group, and this one " \
           "drops them."
    },
    "pattern-uncons" => {
      parse_error: true,
      why: "`f x :: xs = ...` isn't valid Elm. The old parser accepted it, but tree-sitter rejects it, so this " \
           "representer gives it Basic's representation."
    }
  }.freeze

  # Every fixture's module is called Boilerplate, apart from the two tests
  # of the module's name, which call it Bob.
  BOB = %w[exports-exposed-things exports-module-name].freeze
  MODULES = {
    ["Bob"] => BOB,
    ["Boilerplate"] => Dir[File.join(__dir__, "../fixtures/elm/*")].map { |dir| File.basename(dir) } - BOB -
                       ["pattern-uncons"]
  }.freeze

  upstream_tests ".elm",
    deviations: DEVIATIONS,
    renamed: MODULES,
    renamed_why: "The solution defines its module, so this representer renames the module's name. The old " \
                 "representer kept it."

  # The upstream tests for the names that Elm imports into every module.
  # The old representer kept these names, even where the solution defined
  # them. This representer renames every name the solution defines.
  %w[toFloat round floor ceiling truncate max min compare not xor modBy remainderBy
     negate abs clamp sqrt logBase e pi cos sin tan acos asin atan atan2
     degrees radians turns toPolar fromPolar isNaN isInfinite identity always never
     number comparable appendable compappend].each do |word|
    define_method("test_upstream_a_function_called_#{word}_is_renamed") do
      assert_same_representation "#{word} x =\n    x", "zzz x =\n    x"
    end
  end

  %w[Int Float Order GT EQ LT Bool True False Never List Maybe Just Result Ok
     Err String Char Tuple Debug Program Cmd Sub].each do |word|
    define_method("test_upstream_a_type_called_#{word}_is_renamed") do
      assert_same_representation "type #{word} = Zzz", "type Yyy = Zzz"
    end
  end

  def test_names_are_renamed_by_kind
    assert_same_representation "x =\n    1", "y =\n    1"
    refute_same_representation "type X = A", "type X = A Int"
  end

  def wrap(body) = "module M exposing (f)\n\n#{body}\n"

  def test_comments_are_dropped
    assert_same_representation wrap("f x =\n    x"), wrap("-- a\n{- b -}\n{-| c -}\nf x =\n    -- d\n    x")
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation wrap("f a =\n    let\n        b = a\n    in\n    b"),
      wrap("f x =\n    let\n        y = x\n    in\n    y")
    refute_same_representation wrap("f a b =\n    a"), wrap("f a b =\n    b")
  end

  def test_fields_are_renamed_through_dots
    code = "type alias R =\n    { %s : Int }\n\nf r =\n    r.%s\n\ng =\n    { %s = 1 }\n\nh =\n    .%s"
    assert_same_representation wrap(format(code, "a", "a", "a", "a")), wrap(format(code, "b", "b", "b", "b"))
  end

  def test_constructors_are_renamed_where_they_are_used
    code = "type T\n    = %s\n\nf =\n    %s"
    assert_same_representation wrap(format(code, "A", "A")), wrap(format(code, "B", "B"))
  end

  def test_names_after_a_module_dot_keep_their_names
    refute_same_representation wrap("f xs =\n    List.map xs"), wrap("f xs =\n    List.filter xs")
    refute_same_representation wrap("map xs =\n    List.map xs"), wrap("map xs =\n    List.filter xs")
  end

  def test_constrained_type_variables_keep_their_names
    refute_same_representation wrap("f : number -> number\nf x =\n    x"), wrap("f : a -> a\nf x =\n    x")
    assert_same_representation wrap("f : a -> a\nf x =\n    x"), wrap("f : b -> b\nf x =\n    x")
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "module M exposing (..)\n\nf =\n"
  end

  # A field named like a library function is renamed, like any other field.
  def test_members_named_like_library_functions_are_renamed
    assert_same_representation "module A exposing (f)\ntype alias R = { sum : Int }\nf xs = { sum = 1 }\n",
      "module A exposing (f)\ntype alias R = { product : Int }\nf xs = { product = 1 }\n"
    assert_same_representation "module A exposing (f)\ntype alias R = { total : Int }\nf xs = { total = List.sum xs }\n",
      "module A exposing (f)\ntype alias R = { count : Int }\nf xs = { count = List.sum xs }\n"
  end
end
