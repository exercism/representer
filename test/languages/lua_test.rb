require "test_helper"

# Tests Rosetta as a whole on Lua solutions. The tests of each stage are in
# test/languages/lua/.
class LuaTest < RosettaTest
  track "lua"

  def wrap(body) = "local function f(a, b)\n#{body}\nend\n"

  def test_comments_and_formatting
    assert_same_representation "-- c\nlocal function f()\n  return 1 -- x\nend\n", "local function f() return 1 end"
    assert_same_representation wrap("local c = (a + b)\nreturn c"), wrap("local c = a + b return c")
    refute_same_representation wrap("return (a + b) * a"), wrap("return a + b * a")
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation wrap("local total = a + b\nreturn total"), wrap("local sum = a + b\nreturn sum")
    assert_same_representation "local M = {}\nfunction M.add(x) return x end\nreturn M",
                               "local Calc = {}\nfunction Calc.plus(y) return y end\nreturn Calc"
    refute_same_representation wrap("local total = a + b\nreturn total"), wrap("local total = a + a\nreturn total")
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation wrap("return #a .. string.upper(b)"), wrap("return #a .. string.lower(b)")
  end

  def test_imports_are_dropped
    assert_same_representation "local inspect = require('inspect')\nlocal x = 1", "local x = 1"
    assert_same_representation "require 'strict'\nlocal x = 1", "local x = 1"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation wrap("return a + 0x1F"), wrap("return a + 31")
    assert_same_representation wrap("return 'you'"), wrap('return "you"')
    refute_same_representation wrap("return 'you'"), wrap("return 'me'")
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "local function f( "
  end
end
