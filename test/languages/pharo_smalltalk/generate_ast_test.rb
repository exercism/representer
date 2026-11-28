require_relative "stage_helper"

# Tests Pharo Smalltalk's GenerateAST stage. Each assert_same pair is the
# same program to Pharo's parser, and each refute_same pair is a different
# program.
class PharoSmalltalkGenerateASTTest < Minitest::Test
  include PharoSmalltalkStages

  def test_layout_brackets_and_periods_make_no_difference
    assert_same "Foo >> bar [ ^ (a foo) bar ]", "Foo >> bar [\n\t^ a foo bar.\n]"
    assert_same "Foo >> bar [ a foo. b bar ]", "Foo >> bar [ a foo.. b bar. ]"
    assert_same "Class { #name : #Foo }", "Class {#name: #Foo,}"
    refute_same "Foo >> bar [ ^ a + (b * c) ]", "Foo >> bar [ ^ a + b * c ]"
    refute_same "Foo >> bar [ ^ a foo: (b bar: c) ]", "Foo >> bar [ ^ a foo: b bar: c ]"
  end

  def test_each_message_has_one_selector
    assert_equal "(source_file\n  (method_definition Foo\n    (unary_pattern bar)\n    (method_body\n      " \
                 "(keyword_message a at:put: 1 2))))", ast("Foo >> bar [ a at: 1 put: 2 ]")
    refute_same "Foo >> bar [ a at: 1 put: 2 ]", "Foo >> bar [ a at: 1; put: 2 ]"
    refute_same "Foo >> bar [ ^ a ]", "Foo class >> bar [ ^ a ]"
    refute_same "Class { #name : #Foo }", "Trait { #name : #Foo }"
    refute_same "Foo >> bar [ ^ [ a ] ]", "Foo >> bar [ ^ { a } ]"
  end

  def test_strings_and_symbols_are_written_as_their_values
    assert_same "Foo >> bar [ ^ 'it''s' ]", "Foo >> bar [ ^ 'it''s' ]"
    assert_same "Foo >> bar [ ^ #'foo' ]", "Foo >> bar [ ^ #foo ]"
    assert_same "Foo >> bar [ ^ #(foo at:put: + #baz) ]", "Foo >> bar [ ^ #(#foo #at:put: #+ #baz) ]"
    assert_same "Foo >> bar [ ^ #((1 2)) ]", "Foo >> bar [ ^ #(#(1 2)) ]"
    refute_same "Foo >> bar [ ^ #foo ]", "Foo >> bar [ ^ 'foo' ]"
    refute_same "Foo >> bar [ ^ $a ]", "Foo >> bar [ ^ 'a' ]"
    refute_same "Foo >> bar [ ^ #(true) ]", "Foo >> bar [ ^ #(#true) ]"
  end

  def test_numbers_are_written_as_their_values
    assert_same "Foo >> bar [ ^ 16rFF ]", "Foo >> bar [ ^ 255 ]"
    assert_same "Foo >> bar [ ^ 2r1010 ]", "Foo >> bar [ ^ 10 ]"
    assert_same "Foo >> bar [ ^ 1.50 ]", "Foo >> bar [ ^ 1.5 ]"
    refute_same "Foo >> bar [ ^ 1 ]", "Foo >> bar [ ^ 1.0 ]"
    refute_same "Foo >> bar [ ^ 1e10 ]", "Foo >> bar [ ^ 10000000000.0 ]"
    refute_same "Foo >> bar [ ^ 1.5s2 ]", "Foo >> bar [ ^ 1.5 ]"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
