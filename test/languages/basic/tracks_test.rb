require "test_helper"

# Tests what Basic knows about each track: its Rouge lexer and which of its
# files are source files.
class BasicTracksTest < Minitest::Test
  Basic = Rosetta::Languages::Basic

  def test_finds_a_lexer_named_after_the_track_or_mapped_to_it
    assert_equal "haskell", Basic.lexer_for("haskell").tag
    assert_equal "haskell", Basic.lexer_for("purescript").tag
    assert_nil Basic.lexer_for("8th")
  end

  def test_every_mapped_lexer_exists
    Basic::LEXERS.each { |track, name| refute_nil Rouge::Lexer.find(name), track }
  end

  def test_reads_the_file_names_listed_by_the_lexer
    assert Basic.source_file?("haskell", "src/Main.hs")
    refute Basic.source_file?("haskell", "package.yaml")
  end

  def test_reads_the_listed_extensions
    assert Basic.source_file?("purescript", "src/Main.purs")
    refute Basic.source_file?("purescript", "src/Main.hs")
  end

  def test_reads_every_file_except_documents_and_data_for_a_track_with_neither
    assert Basic.source_file?("no-such-track", "main.anything")
    refute Basic.source_file?("no-such-track", "HELP.md")
    refute Basic.source_file?("no-such-track", "notes.TXT")
  end

  def test_leaves_out_test_files
    refute Basic.source_file?("haskell", "test/LeapSpec_test.hs")
  end
end
