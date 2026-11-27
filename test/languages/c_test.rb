require "test_helper"

class CTest < RepresenterTest
  track "c"

  def test_comments_and_includes_go
    assert_same_representation "int f(void) { return 1; }",
      "#include <stdio.h>\n#include \"leap.h\"\n// note\nint f(void) { return 1; /* done */ }\n"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation "int f(void) { return 0x10 == 16 && \"a\" \"b\"[0]; }",
      "int g(void) { return 16 == 16 && \"ab\"[0]; }"
    refute_same_representation "unsigned f(void) { return 10u; }", "unsigned f(void) { return 10; }"
  end

  def test_types_fields_and_functions_are_renamed
    code = "typedef struct { int %s; } %s;\nint %s(%s p) { return p.%s; }"
    assert_same_representation format(code, "x", "point_t", "get_x", "point_t", "x"),
      format(code, "y", "coord", "read", "coord", "y")
  end

  def test_names_from_the_standard_library_keep_their_names
    refute_same_representation "size_t f(const char *s) { return strlen(s); }", "size_t f(const char *s) { return strnlen(s); }"
    refute_same_representation "int f(int a) { return abs(a); }", "int f(int a) { return labs(a); }"
  end

  def test_a_header_and_its_source_file_are_joined
    header = "#ifndef LEAP_H\n#define LEAP_H\n#include <stdbool.h>\nbool leap_year(int year);\n#endif\n"
    source = "#include \"leap.h\"\nbool leap_year(int year) { return year % 4 == 0; }\n"
    renamed = { "leap.h" => header.gsub("year", "y"), "leap.c" => source.gsub("year", "y") }
    assert_equal Representer::RepresentSolution.("c", { "leap.h" => header, "leap.c" => source }).representation,
      Representer::RepresentSolution.("c", renamed).representation
  end

  def test_syntax_errors_get_a_basic_representation_with_the_c_version
    assert_basic_representation "int f( {"
  end
end
