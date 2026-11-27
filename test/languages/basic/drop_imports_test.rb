require "test_helper"

# Tests Basic's DropImports, which drops the imports and export lists from
# the lines given by Tokenise.
class BasicDropImportsTest < Minitest::Test
  def drop_imports(source, track:)
    lines = Representer::Languages::Basic::Tokenise.(track, source)
    Representer::Languages::Basic::DropImports.(track, lines).map(&:last)
  end

  def test_drops_a_line_that_starts_with_an_import_word
    assert_equal [["fun", "f", "()", "=", "1"]], drop_imports("import kotlin.math.abs\nfun f() = 1\n", track: "kotlin")
  end

  def test_keeps_a_line_that_only_starts_like_an_import
    assert_equal [["fun", "f", "()", "=", "importer", "()"]], drop_imports("fun f() = importer()\n", track: "kotlin")
  end

  def test_drops_the_more_indented_lines_that_continue_a_haskell_import
    assert_equal [["a", "=", "1"]], drop_imports("import Data.List (sort,\n    nub)\na = 1\n", track: "haskell")
  end

  def test_drops_a_directive_up_to_its_full_stop
    erlang = "-export([f/1,\n  g/1]).\nf(X) -> X.\n"
    assert_equal drop_imports("f(X) -> X.\n", track: "erlang"), drop_imports(erlang, track: "erlang")
  end

  def test_drops_the_export_list_from_a_module_line
    assert_equal [%w[module A where]], drop_imports("module A (a, b) where\n", track: "haskell")
  end

  def test_keeps_imports_in_a_track_with_no_import_words
    assert_equal [%w[import x]], drop_imports("import x\n", track: "8th")
  end
end
