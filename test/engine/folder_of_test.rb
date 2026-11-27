require "test_helper"

class FolderOfTest < Minitest::Test
  def test_splits_a_name_into_words_at_each_capital_after_a_lower_case_letter
    assert_equal "emacs_lisp", folder("EmacsLisp")
    assert_equal "csharp", folder("CSharp")
    assert_equal "fsharp", folder("FSharp")
    assert_equal "ruby", folder("Ruby")
  end

  def test_keeps_the_names_that_are_one_word_together
    assert_equal "javascript", folder("JavaScript")
    assert_equal "typescript", folder("TypeScript")
  end

  def test_finds_the_folders_of_javascript_and_typescript
    assert File.directory?(Representer::Engine.folder_of(Representer::Languages::JavaScript))
    assert File.directory?(Representer::Engine.folder_of(Representer::Languages::TypeScript))
  end

  private
  def folder(name) = File.basename(Representer::Engine.folder_of(Struct.new(:name).new("Representer::Languages::#{name}")))
end
