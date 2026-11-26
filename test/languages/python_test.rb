require "test_helper"

class PythonTest < RepresenterTest
  extend UpstreamTests

  track "python"

  REASONS = {
    library: "This representer never renames a method or function that has the name of a Python library method " \
             "(reverse, add, read...), so mentors' comments on different library calls stay apart. " \
             "The old representer renamed them.",
    called: "Python calls dunder methods (__init__, __add__...) itself, and `_` is the conventional throwaway name, " \
            "so this representer keeps them. The old representer renamed them.",
    double: "The old representer visited comprehension variables twice, so its mapping holds a placeholder as if " \
            "it were a name from the solution. This representer has no such entry.",
    kwargs: "This representer only renames a keyword argument if it is a name the solution defines. " \
            "A keyword argument of a library call (dict(win=0), Thread(target=...)) keeps its name. " \
            "The old representer renamed every keyword argument.",
    stores: "This representer only renames an attribute that a solution defines on self or cls. " \
            "An attribute set on any other object (ctx.prec = 18) keeps its name. The old representer renamed it.",
    match: "This representer renames the names that `case` patterns capture. The old representer didn't."
  }.freeze

  def self.reasons(*keys) = keys.map { |key| REASONS.fetch(key) }.join(" ")

  DEVIATIONS = {
    "concept-ellens-alien-game" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "concept-mecha-munch-management" => {
      remove: %w[reverse],
      why: reasons(:library)
    },
    "concept-pretty-leaflet" => {
      remove: %w[_],
      why: reasons(:called)
    },
    "concept-restaurant-rozalynn" => {
      remove: %w[_],
      why: reasons(:called)
    },
    "example-class-normalization" => {
      remove: %w[__init__ clear read write],
      why: reasons(:called, :library)
    },
    "example-dataclass-normalization" => {
      remove: %w[_ __add__ __eq__ __init__ __lt__ __post_init__ advance default default_factory
                 eq frozen init kw_only match_args namespace order search slots
                 unsafe_hash weakref_slot],
      why: reasons(:called, :kwargs, :library)
    },
    "example-docstring-removal" => {
      remove: %w[__new__ __slots__],
      why: reasons(:called)
    },
    "example-expression-normalization" => {
      remove: %w[_ maxsplit placeholder_3],
      why: reasons(:called, :kwargs, :double)
    },
    "example-lambda-normalization" => {
      remove: %w[key],
      why: reasons(:kwargs)
    },
    "example-parencontext-normalization" => {
      remove: %w[mode prec rounding],
      why: reasons(:library, :stores)
    },
    "example-typehints-removal" => {
      add: %w[n],
      why: reasons(:match)
    },
    "example-uniondict-normalization" => {
      remove: %w[_],
      why: reasons(:called)
    },
    "example-walrus-normalization" => {
      remove: %w[_ placeholder_17],
      why: reasons(:called, :double)
    },
    "practice-accumulate" => {
      remove: %w[accumulate],
      why: reasons(:library)
    },
    "practice-affine-cipher" => {
      remove: %w[decode encode translate],
      why: reasons(:library)
    },
    "practice-allergies" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-alphametics" => {
      remove: %w[_ placeholder_37],
      why: reasons(:called, :double)
    },
    "practice-atbash-cipher" => {
      remove: %w[decode encode],
      why: reasons(:library)
    },
    "practice-bank-account" => {
      remove: %w[__init__ close],
      why: reasons(:called, :library)
    },
    "practice-binary-search" => {
      remove: %w[find],
      why: reasons(:library)
    },
    "practice-binary-search-tree" => {
      remove: %w[__init__ __str__ add],
      why: reasons(:called, :library)
    },
    "practice-book-store" => {
      remove: %w[_],
      why: reasons(:called)
    },
    "practice-bowling" => {
      remove: %w[__init__ throw],
      why: reasons(:called, :library)
    },
    "practice-circular-buffer" => {
      remove: %w[__init__ clear read write],
      why: reasons(:called, :library)
    },
    "practice-clock" => {
      remove: %w[__add__ __eq__ __init__ __repr__ __str__ __sub__],
      why: reasons(:called)
    },
    "practice-complex-numbers" => {
      remove: %w[__abs__ __add__ __eq__ __init__ __mul__ __radd__ __rmul__ __rsub__ __rtruediv__
                 __sub__ __truediv__ conjugate exp],
      why: reasons(:called, :library)
    },
    "practice-connect" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-crypto-square" => {
      remove: %w[fillvalue],
      why: reasons(:kwargs)
    },
    "practice-custom-set" => {
      remove: %w[__add__ __contains__ __eq__ __init__ __iter__ __sub__ add intersection
                 isdisjoint issubset],
      why: reasons(:called, :library)
    },
    "practice-dnd-character" => {
      remove: %w[_ __init__],
      why: reasons(:called)
    },
    "practice-dot-dsl" => {
      remove: %w[__eq__ __init__],
      why: reasons(:called)
    },
    "practice-forth" => {
      remove: %w[__init__ is_integer],
      why: reasons(:called, :library)
    },
    "practice-gigasecond" => {
      remove: %w[add seconds],
      why: reasons(:library, :kwargs)
    },
    "practice-go-counting" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-grade-school" => {
      remove: %w[__init__ add],
      why: reasons(:called, :library)
    },
    "practice-grep" => {
      remove: %w[_ encoding start],
      why: reasons(:called, :kwargs)
    },
    "practice-hangman" => {
      remove: %w[_ __init__],
      why: reasons(:called)
    },
    "practice-high-scores" => {
      remove: %w[__init__ reverse],
      why: reasons(:called, :library)
    },
    "practice-killer-sudoku-helper" => {
      remove: %w[combinations],
      why: reasons(:library)
    },
    "practice-kindergarten-garden" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-knapsack" => {
      remove: %w[_ placeholder_4],
      why: reasons(:called, :double)
    },
    "practice-ledger" => {
      remove: %w[__init__ truncate],
      why: reasons(:called, :library)
    },
    "practice-linked-list" => {
      remove: %w[__init__ __iter__ __len__ pop],
      why: reasons(:called, :library)
    },
    "practice-list-ops" => {
      remove: %w[_ append concat reverse],
      why: reasons(:called, :library)
    },
    "practice-luhn" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-matrix" => {
      remove: %w[__init__ placeholder_4],
      why: reasons(:called, :double)
    },
    "practice-meetup" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-nucleotide-count" => {
      remove: %w[count],
      why: reasons(:library)
    },
    "practice-ocr-numbers" => {
      remove: %w[placeholder_4],
      why: reasons(:double)
    },
    "practice-paasio" => {
      remove: %w[__enter__ __exit__ __init__ __iter__ __next__ read send write],
      why: reasons(:called, :library)
    },
    "practice-parallel-letter-frequency" => {
      remove: %w[_ __init__ args target],
      why: reasons(:called, :kwargs)
    },
    "practice-phone-number" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-pig-latin" => {
      remove: %w[translate],
      why: reasons(:library)
    },
    "practice-poker" => {
      remove: %w[_ reverse],
      why: reasons(:called, :library)
    },
    "practice-pov" => {
      remove: %w[__dict__ __eq__ __init__ __iter__ __lt__ __str__ add remove],
      why: reasons(:called, :library)
    },
    "practice-queen-attack" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-rail-fence-cipher" => {
      remove: %w[_ decode encode key],
      why: reasons(:called, :library, :kwargs)
    },
    "practice-rational-numbers" => {
      remove: %w[__abs__ __add__ __eq__ __init__ __mul__ __neg__ __pow__ __repr__ __rpow__
                 __sub__ __truediv__],
      why: reasons(:called)
    },
    "practice-react" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-rectangles" => {
      remove: %w[_ __init__ __str__ r],
      why: reasons(:called, :kwargs)
    },
    "practice-rest-api" => {
      remove: %w[__init__ get update],
      why: reasons(:called, :library)
    },
    "practice-reverse-string" => {
      remove: %w[reverse],
      why: reasons(:library)
    },
    "practice-robot-name" => {
      remove: %w[_ __init__],
      why: reasons(:called)
    },
    "practice-robot-simulator" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-rotational-cipher" => {
      remove: %w[rotate],
      why: reasons(:library)
    },
    "practice-run-length-encoding" => {
      remove: %w[decode encode],
      why: reasons(:library)
    },
    "practice-saddle-points" => {
      remove: %w[_],
      why: reasons(:called)
    },
    "practice-scale-generator" => {
      remove: %w[_ __init__],
      why: reasons(:called)
    },
    "practice-sgf-parsing" => {
      remove: %w[default_factory],
      why: reasons(:kwargs)
    },
    "practice-simple-cipher" => {
      remove: %w[_ __init__ decode encode],
      why: reasons(:called, :library)
    },
    "practice-simple-linked-list" => {
      remove: %w[__init__ __iter__ __len__ __next__ pop],
      why: reasons(:called, :library)
    },
    "practice-space-age" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-spiral-matrix" => {
      remove: %w[_],
      why: reasons(:called)
    },
    "practice-strain" => {
      remove: %w[discard],
      why: reasons(:library)
    },
    "practice-sublist" => {
      remove: %w[_ contains],
      why: reasons(:called, :library)
    },
    "practice-tournament" => {
      remove: %w[draw key loss win],
      why: reasons(:kwargs)
    },
    "practice-transpose" => {
      remove: %w[key placeholder_4],
      why: reasons(:kwargs, :double)
    },
    "practice-tree-building" => {
      remove: %w[__init__],
      why: reasons(:called)
    },
    "practice-variable-length-quantity" => {
      remove: %w[decode encode],
      why: reasons(:library)
    },
    "practice-word-search" => {
      remove: %w[__add__ __eq__ __init__ __ne__ __repr__ __sub__ find search],
      why: reasons(:called, :library)
    },
    "practice-zebra-puzzle" => {
      remove: %w[_ placeholder_11],
      why: reasons(:called, :double)
    },
    "practice-zipper" => {
      remove: %w[__init__],
      why: reasons(:called)
    }
  }.freeze

  upstream_tests ".py", deviations: DEVIATIONS

  def test_comments_print_statements_and_main_guards_go
    assert_same_representation "def f(a):\n    return a",
      "# note\ndef f(a):\n    print(a)\n    return a  # done\n\nif __name__ == '__main__':\n    f(1)"
    assert_same_representation "x = 1", "x = 1\nprint(x)\nif '__main__' == __name__:\n    print(x)"
    refute_same_representation "x = 1", "x = 1\nif __name__ == 'other':\n    pass"
  end

  def test_docstrings_go
    assert_same_representation "def f(a):\n    return a", "def f(a):\n    '''Docs.'''\n    return a"
    assert_same_representation "class A:\n    x = 1", "class A:\n    \"Docs\"\n    x = 1"
    assert_same_representation "x = 1", "\"\"\"Module docs\"\"\"\nx = 1"
    refute_same_representation "def f():\n    return 'a'", "def f():\n    return 'b'"
  end

  def test_empty_bodies_are_pass
    assert_same_representation "def f():\n    pass", "def f():\n    '''Docs.'''"
    assert_same_representation "def f():\n    pass", "def f():\n    print(1)"
    refute_same_representation "def f():\n    pass", "def f():\n    ..."
  end

  def test_type_hints_go
    assert_same_representation "def f(a, b=1, *c, **d):\n    x = 1",
      "def f(a: int, b: int = 1, *c: str, **d: str) -> None:\n    x: int = 1"
    assert_same_representation "class A:\n    x = None", "class A:\n    x: int"
    refute_same_representation "def f(a): return a", "def g(a, b): return a"
  end

  def test_strings_are_their_values
    assert_same_representation "x = 'a b'", 'x = "a b"'
    assert_same_representation "x = 'a\\nb'", "x = '''a\nb'''"
    assert_same_representation "x = 'ab'", "x = 'a' \"b\""
    assert_same_representation "x = r'a\\n'", "x = 'a\\\\n'"
    refute_same_representation "x = 'a'", "x = b'a'"
    refute_same_representation "x = 'a\\n'", "x = 'a\\\\n'"
    refute_same_representation "x = 'a\\qb'", "x = 'a\\\\qb'"
  end

  def test_f_strings_keep_their_substitutions
    assert_same_representation "f = lambda n: f'a {n}'", "f = lambda m: f\"a {m}\""
    refute_same_representation "f = lambda n: f'a {n}'", "f = lambda n: f'a{n}'"
    refute_same_representation "f = lambda n: f'a {n!r}'", "f = lambda n: f'a {n}'"
    refute_same_representation "f = lambda n: f'{n:>10}'", "f = lambda n: f'{n:<10}'"
    assert_same_representation "f = lambda n: f'{n}'", "f = lambda m: f'{m}'"
  end

  def test_numbers_are_their_values
    assert_same_representation "x = 1000", "x = 1_000"
    assert_same_representation "x = 16", "x = 0x10"
    assert_same_representation "x = 1000.0", "x = 1e3"
    assert_same_representation "x = 2j", "x = 2.0J"
    refute_same_representation "x = 1", "x = 1.0"
  end

  def test_elif_is_else_if
    assert_same_representation "if a:\n    b\nelif c:\n    d\nelse:\n    e",
      "if a:\n    b\nelse:\n    if c:\n        d\n    else:\n        e"
    refute_same_representation "if a:\n    b\nelse:\n    c\n    if d:\n        e", "if a:\n    b\nelif d:\n    e"
  end

  def test_grouping_and_tuples
    assert_same_representation "x = (a + b) + c", "x = a + b + c"
    refute_same_representation "x = a * (b + c)", "x = a * b + c"
    assert_same_representation "x = 1, 2", "x = (1, 2)"
    assert_same_representation "a, b = x", "(a, b) = x"
    refute_same_representation "x = (1,)", "x = 1"
  end

  def test_a_lone_generator_argument
    assert_same_representation "x = sum(n for n in a)", "x = sum((n for n in a))"
  end

  def test_slices_stay_apart
    refute_same_representation "x = a[1:]", "x = a[:1]"
  end

  def test_match_sequences
    assert_same_representation "match x:\n    case (1, 2):\n        pass", "match x:\n    case [1, 2]:\n        pass"
  end

  def test_names_python_uses_are_kept
    code = "class A:\n    def __init__(self, xs):\n        self.xs = xs\n    def f(self):\n        return len(self.xs)"
    names = represent(code).mapping.values
    assert_equal %w[A xs f], names
  end

  def test_members_are_renamed_only_if_the_solution_defines_them
    assert_same_representation "class A:\n    def go(self): self.n = 1", "class B:\n    def run(self): self.m = 1"
    refute_same_representation "def f(xs): return xs.upper()", "def f(xs): return xs.lower()"
    refute_same_representation "def f(count, xs): return xs.count(count)", "def f(count, xs): return xs.index(count)"
    assert_same_representation "def f(count, xs): return xs.count(count)", "def f(num, xs): return xs.count(num)"
  end

  def test_methods_named_after_library_methods_stay_apart
    refute_same_representation "class A:\n    def reverse(self): return self.a.reverse()",
      "class A:\n    def sort(self): return self.a.sort()"
  end

  def test_keyword_arguments_follow_the_parameters_they_name
    assert_same_representation "def f(a, b=1): pass\nf(a=2)", "def f(x, y=1): pass\nf(x=2)"
    refute_same_representation "x = sorted(a, key=len)", "x = sorted(a, reverse=len)"
  end

  def test_imports
    assert_same_representation "import numpy as np\nx = np.pi", "import numpy as n\nx = n.pi"
    refute_same_representation "import math\nx = math.pi", "import cmath\nx = cmath.pi"
    refute_same_representation "from math import sqrt", "from math import floor"
  end

  def test_match_captures_are_names
    assert_same_representation "match x:\n    case [a, *rest]:\n        pass", "match x:\n    case [b, *others]:\n        pass"
    refute_same_representation "match x:\n    case Color.RED:\n        pass", "match x:\n    case Color.BLUE:\n        pass"
  end

  def test_names_in_the_tests_are_kept
    test = "from two_fer import two_fer\nclass T:\n    def test(self):\n        assert two_fer(name='x') == 'y'"
    tests = { "two_fer_test.py" => test }
    result = represent("def two_fer(name='you'):\n    return name", filename: "two_fer.py", exercise_files: tests)
    assert_empty result.mapping
  end

  def test_syntax_errors_are_unrepresentable_with_the_python_version
    result = represent("def (:")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::Python.version, result.version
  end

  # A trailing comma makes a tuple in a subscript and in a match.
  def test_a_trailing_comma_that_makes_a_tuple_is_kept
    refute_same_representation "x = a[1,]\n", "x = a[1]\n"
    refute_same_representation "match x:\n    case 1,:\n        pass\n", "match x:\n    case 1:\n        pass\n"
    refute_same_representation "match x,:\n    case 1:\n        pass\n", "match x:\n    case 1:\n        pass\n"
  end
end
