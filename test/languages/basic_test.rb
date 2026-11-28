require "test_helper"

class BasicTest < InspectorTest
  track "haskell"

  # Almost every track has a language of its own, so the tests call Basic
  # directly.
  def basic(code, track: "haskell") = Inspector::Languages::Basic.(track, { FILENAMES.fetch(track) => code })
  def represent(code, filename: default_filename) = Inspector::Languages::Basic.(track, { filename => code })
  def default_filename = FILENAMES.fetch(track)

  # Basic only reads a track's source files.
  FILENAMES = {
    "haskell" => "Main.hs", "python" => "main.py", "dart" => "main.dart", "8th" => "main.8th", "emacs-lisp" => "main.el",
    "scheme" => "main.scm", "haxe" => "Main.hx", "c" => "main.c",
    "erlang" => "main.erl"
  }.freeze

  def test_basic_gives_its_own_version_and_no_mapping
    result = basic(": main 1 . ;", track: "8th")
    assert_equal Inspector::Languages::Basic, result.language
    assert_nil result.reason
    assert_equal Inspector::Languages::Basic::VERSION, result.version
    assert_empty result.mapping
  end

  def test_comments_and_spacing_are_ignored
    assert_same_representation "f x = x + 1 -- add one", "f  x=x+1\n\n{- a\nblock -}"
  end

  def test_whitespace_inside_strings_is_kept
    refute_same_representation 'f = "One for you"', 'f = "Oneforyou"'
    refute_same_representation 'f = "a  b"', 'f = "a b"'
  end

  def test_tokens_stay_apart
    refute_same_representation "f = a b", "f = ab"
  end

  def test_indentation_depth_is_kept_in_indentation_sensitive_languages
    loop_inside = "for x in xs:\n    print(x)\n    done(x)\n"
    loop_after = "for x in xs:\n    print(x)\ndone(x)\n"
    refute_equal basic(loop_inside, track: "python").representation, basic(loop_after, track: "python").representation
    assert_equal basic(loop_inside, track: "python").representation,
      basic("for x in xs:\n  print(x)\n  done(x)\n", track: "python").representation
  end

  def test_indentation_is_ignored_elsewhere
    assert_equal basic("if (x) {\n    y();\n}", track: "dart").representation,
      basic("if (x) {\ny();\n  }", track: "dart").representation
  end

  def test_line_breaks_are_kept
    refute_equal basic("return\nx", track: "dart").representation, basic("return x", track: "dart").representation
  end

  def test_tracks_without_a_lexer_split_at_whitespace
    assert_equal basic("x =  1", track: "8th").representation, basic("x = 1", track: "8th").representation
    refute_equal basic("x = 1", track: "8th").representation, basic("x =1", track: "8th").representation
  end

  def test_file_names_and_order_do_not_matter
    one = Inspector::RepresentSolution.("dart", { "a.dart" => "x = 1;", "b.dart" => "y = 2;" })
    other = Inspector::RepresentSolution.("dart", { "c.dart" => "y = 2;", "a.dart" => "x = 1;", "d.dart" => "" })
    assert_equal one.representation, other.representation
    refute_includes one.representation, "a.dart"
  end

  # Rouge reads these literals as the start of a comment or string, which
  # would drop the rest of the line.
  def test_character_literals_that_look_like_comments_keep_the_rest_of_the_line
    refute_equal basic("(insert ?;) (foo 1)", track: "emacs-lisp").representation,
      basic("(insert ?;) (foo 2)", track: "emacs-lisp").representation
    refute_equal basic("(insert ?\") (foo \"a\")", track: "emacs-lisp").representation,
      basic("(insert ?\") (foo \"b\")", track: "emacs-lisp").representation
    refute_equal basic('(display #\;) (foo 1)', track: "scheme").representation,
      basic('(display #\;) (foo 2)', track: "scheme").representation
    assert_equal basic('(insert ?\;) ; a comment', track: "emacs-lisp").representation,
      basic('(insert ?\;)', track: "emacs-lisp").representation
  end

  def test_a_haxe_regex_with_slashes_is_not_a_comment
    refute_equal basic('var r = ~/\/\//; var x = 1;', track: "haxe").representation,
      basic('var r = ~/\/\//; var x = 2;', track: "haxe").representation
    assert_equal basic("var r = ~/a/g; // c", track: "haxe").representation, basic("var r = ~/a/g;", track: "haxe").representation
  end

  def test_a_line_comment_after_a_preprocessor_line_is_dropped
    assert_equal basic("#define Y 2 // two\nint x;", track: "c").representation,
      basic("#define Y 2\nint x;", track: "c").representation
    refute_equal basic("#define Z \"a//b\"\n", track: "c").representation, basic("#define Z \"a\"\n", track: "c").representation
  end

  def test_files_that_are_not_code_are_ignored
    code = { "src/Main.hs" => "main = print 1" }
    with_config = code.merge("package.yaml" => "name: leap", "HELP.md" => "# Help", "test/LeapSpec_test.hs" => "x")
    assert_equal Inspector::RepresentSolution.("haskell", code).representation,
      Inspector::RepresentSolution.("haskell", with_config).representation
    assert_equal "1", Inspector::Languages::Basic.("groovy", { "a.groovy" => "1", "notes.txt" => "2" }).representation
    assert_equal "no_source_files", Inspector::RepresentSolution.("haskell", { "package.yaml" => "x" }).reason
  end

  def test_imports_on_their_own_lines_are_dropped
    groovy = Inspector::Languages::Basic.("groovy", { "a.groovy" => "import java.time.Year\ndef f() { 1 }\n" })
    assert_equal Inspector::Languages::Basic.("groovy", { "a.groovy" => "def f() { 1 }\n" }).representation,
      groovy.representation
    c = basic("#include <stdio.h>\n#include \"a.h\"\nint f() { return 1; }\n", track: "c")
    assert_equal basic("int f() { return 1; }\n", track: "c").representation, c.representation
    haskell = "module A (a, b) where\nimport Data.List (sort,\n    nub)\na = 1\n"
    assert_equal basic("module A where\na = 1\n").representation, basic(haskell).representation
  end

  def test_erlang_and_prolog_directives_that_import_or_export_are_dropped
    erlang = "-module(a).\n-export([f/1,\n  g/1]).\n-include_lib(\"eunit/include/eunit.hrl\").\nf(X) -> X.\n"
    assert_equal basic("-module(a).\nf(X) -> X.\n", track: "erlang").representation,
      basic(erlang, track: "erlang").representation
    prolog = ":- use_module(library(lists)).\nf(X) :- X.\n"
    assert_equal Inspector::Languages::Basic.("prolog", { "a.pl" => "f(X) :- X.\n" }).representation,
      Inspector::Languages::Basic.("prolog", { "a.pl" => prolog }).representation
  end

  def test_a_line_that_only_starts_like_an_import_stays
    with_call = Inspector::Languages::Basic.("groovy", { "a.groovy" => "def f() { importer() }\n" })
    refute_equal Inspector::Languages::Basic.("groovy", { "a.groovy" => "def f() { 1 }\n" }).representation,
      with_call.representation
  end
end
