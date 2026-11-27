require_relative "stage_helper"

# Tests Lua's GenerateAST stage, which gives one tree to code that differs
# only in comments, layout, brackets that only group and the spellings that
# Lua's parser reads the same way.
class LuaGenerateASTTest < Minitest::Test
  include LuaStages

  def test_drops_comments_and_layout
    assert_same "-- c\nlocal x = 1 -- x\n--[[ long\ncomment ]]\n", "local x=1"
    assert_same "local x = 1;;", "local x = 1"
    assert_same "local t = {1, 2; 3,}", "local t = {1, 2, 3}"
  end

  def test_unwraps_brackets_that_only_group
    assert_same wrap("return (a + b)"), wrap("return a + b")
    refute_same wrap("return (a + b) * a"), wrap("return a + b * a")
  end

  def test_keeps_brackets_that_keep_only_the_first_value
    refute_same wrap("return (g())"), wrap("return g()")
    refute_same "local function f(...) return (...) end", "local function f(...) return ... end"
  end

  def test_calls_without_brackets_are_calls
    assert_same wrap('g "s"'), wrap('g("s")')
    assert_same wrap("g {1}"), wrap("g({1})")
  end

  def test_function_declarations_are_assignments
    assert_same "function f(x) return x end", "f = function(x) return x end"
    assert_same "function M.f(x) return x end", "M.f = function(x) return x end"
    assert_same "function M:f(x) return x end", "M.f = function(self, x) return x end"
    refute_same "local function f(x) return x end", "local f = function(x) return x end"
  end

  def test_keeps_methods_apart_from_functions
    refute_same wrap("a:g(b)"), wrap("a.g(b)")
  end

  def test_keeps_keys_in_brackets_apart_from_names
    refute_same "local t = {[k] = 1}", "local t = {k = 1}"
    refute_same "local t = {[1] = 2}", "local t = {1, 2}"
  end

  def test_numbers_are_their_values
    assert_same wrap("return a + 0x1F + 010"), wrap("return a + 31 + 10")
    assert_same wrap("return a + 1.50 + 1e3"), wrap("return a + 1.5 + 1000.0")
    refute_same wrap("return a + 1"), wrap("return a + 1.0")
  end

  def test_strings_are_their_values
    assert_same wrap("return 'it\\'s'"), wrap('return "it\'s"')
    assert_same wrap("return [[a\\n]]"), wrap("return 'a\\\\n'")
    assert_same wrap("return [==[\nab]==]"), wrap("return 'ab'")
    assert_same wrap('return "a\\tb\\n"'), wrap("return 'a\\tb\\n'")
    refute_same wrap("return 'a'"), wrap("return 'b'")
    refute_same wrap("return 'a\\n'"), wrap("return [[a\\n]]")
  end

  def test_unknown_escapes_stay_as_they_are
    refute_same wrap("return '\\65'"), wrap("return 'A'")
    refute_same wrap("return '\\x41'"), wrap("return 'A'")
  end

  def test_attributes_are_leaves
    assert_includes ast("local x <const> = 1"), "const"
    refute_same "local x <const> = 1", "local x <close> = 1"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
