require "test_helper"

# Tests Inspector as a whole on Odin solutions. The tests of each stage are in
# test/languages/odin/.
class OdinTest < InspectorTest
  track "odin"

  def test_comments_layout_and_imports_go
    assert_same_representation "package leap\n\nimport \"core:fmt\"\n\n// Says if a year is a leap year.\n" \
                               "is_leap :: proc(year: int) -> bool {\n\t/* The rule */\n" \
                               "\treturn year % 4 == 0 // done\n}\n",
                               "package leap\nis_leap :: proc(year: int) -> bool { return year % 4 == 0 }\n"
  end

  def test_names_the_solution_defines_are_renamed
    code = "package %s\n%s :: struct { %s: int }\n%s :: proc(%s: %s) -> int {\n\t%s := %s.%s * 2\n\treturn %s\n}\n"
    assert_same_representation format(code, "a", "Box", "size", "f", "b", "Box", "n", "b", "size", "n"),
                               format(code, "b", "Item", "count", "g", "it", "Item", "m", "it", "count", "m")
  end

  def test_names_from_the_library_keep_their_names
    refute_same_representation "package a\nf :: proc(s: string) -> string { return strings.to_upper(s) }\n",
                               "package a\nf :: proc(s: string) -> string { return strings.to_lower(s) }\n"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation "package a\nX :: 1_000\nS :: `a`\n", "package a\nX :: 1000\nS :: \"a\"\n"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_odin_version
    assert_basic_representation "package a\nf :: proc( {\n"
  end
end
