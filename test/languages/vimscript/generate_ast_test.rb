require_relative "stage_helper"

# Tests Vimscript's GenerateAST stage. Each assert_same pair has the same
# meaning in Vim, and each refute_same pair has different meanings.
class VimscriptGenerateASTTest < Minitest::Test
  include VimscriptStages

  def test_layout_and_abbreviated_commands_make_no_difference
    assert_same "fun! F(n)\n  retu a:n\nendf\n", "function! F(n)\n  return a:n\nendfunction\n"
    assert_same "if x | return 1 | endif\n", "if x\n  return 1\nendif\n"
    assert_same "let r = a\n      \\ .. b\n", "let r = a .. b\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "let r = (a)\n", "let r = a\n"
    assert_same "let r = f((a), (b + c))\n", "let r = f(a, b + c)\n"
    assert_same "let r = (a && b) || c\n", "let r = a && b || c\n"
    refute_same "let r = a - (b - c)\n", "let r = a - b - c\n"
    refute_same "let r = (a + b) * c\n", "let r = a + b * c\n"
  end

  def test_one_dot_and_two_dots_are_the_same_concatenation
    assert_same "let r = a . b\n", "let r = a .. b\n"
    assert_same "let r = x . y(1)\n", "let r = x .. y(1)\n"
    assert_same "let s .= t\n", "let s ..= t\n"
    refute_same "let r = a . b\n", "let r = a.b\n"
  end

  def test_concatenation_follows_vims_precedence
    assert_same "let r = a - b . c\n", "let r = (a - b) .. c\n"
    refute_same "let r = a - b . c\n", "let r = a - (b . c)\n"
    assert_same "let r = a * b . c\n", "let r = (a * b) .. c\n"
    assert_same "let r = - a . b\n", "let r = (-a) .. b\n"
  end

  def test_nested_conditionals_group_from_the_right
    assert_same "let r = a ? b : c ? d : e\n", "let r = a ? b : (c ? d : e)\n"
    refute_same "let r = a ? b : c ? d : e\n", "let r = (a ? b : c) ? d : e\n"
  end

  def test_operators_stay_apart
    refute_same "let r = a == b\n", "let r = a ==# b\n"
    refute_same "let r = a ==# b\n", "let r = a ==? b\n"
    refute_same "let r = a is b\n", "let r = a == b\n"
    refute_same "let x += 1\n", "let x = 1\n"
  end

  def test_numbers_are_their_values
    assert_same "let r = 0x1F + 017 + 0b11\n", "let r = 31 + 15 + 3\n"
    assert_same "let r = 1.5e3\n", "let r = 1500.0\n"
    assert_same "let r = -1\n", "let r = - 1\n"
    refute_same "let r = 1.0\n", "let r = 1\n"
    refute_same "let r = 10\n", "let r = 010\n"
  end

  def test_strings_are_their_values
    assert_equal ["it's", "a\tb\"c"], literals("let r = 'it''s' .. \"a\\tb\\\"c\"\n")
    assert_same "let r = 'a\\n'\n", "let r = \"a\\\\n\"\n"
    refute_same "let r = 'a\\n'\n", "let r = \"a\\n\"\n"
    refute_same "let r = \"a\\x41\"\n", "let r = \"ax41\"\n"
  end

  def test_a_literal_dictionary_is_a_dictionary
    assert_same 'let r = #{name: 1}', "let r = {'name': 1}"
    refute_same 'let r = #{name: 1}', "let r = {name: 1}"
  end

  def test_local_scope_is_dropped_in_a_function
    assert_same "function! F(x)\n  let l:y = a:x\n  return l:y\nendfunction\n",
      "function! F(x)\n  let y = a:x\n  return y\nendfunction\n"
    refute_same "function! F()\n  let l:count = 1\nendfunction\n", "function! F()\n  let count = 1\nendfunction\n"
  end

  def test_global_scope_is_dropped_outside_functions_and_from_function_names
    assert_same "let g:x = 1\n", "let x = 1\n"
    assert_same "function! g:F()\nendfunction\ncall g:F()\n", "function! F()\nendfunction\ncall F()\n"
    refute_same "function! F()\n  let g:x = 1\nendfunction\n", "function! F()\n  let x = 1\nendfunction\n"
  end

  def test_other_scopes_stay
    refute_same "let s:x = 1\n", "let x = 1\n"
    refute_same "function! F(x)\n  return a:x\nendfunction\n", "function! F(x)\n  return x\nendfunction\n"
    refute_same "function! F(...)\n  return a:0\nendfunction\n", "function! F(...)\n  return a:000\nendfunction\n"
  end

  def test_vim9_script_is_refused
    assert_raises(Inspector::CannotRepresent) { generate_ast("vim9script\ndef g:F(): number\n  return 1\nenddef\n") }
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
