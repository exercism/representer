require "test_helper"

# Tests Rosetta as a whole on Ballerina solutions. The tests of each stage are in
# test/languages/ballerina/.
class BallerinaTest < RosettaTest
  track "ballerina"

  def wrap(body) = "function f(int a, int b) returns int {\n#{body}\n}\n"

  def test_comments_are_dropped
    assert_same_representation "// c\n# doc\nfunction f() { }", "function f() { }"
  end

  def test_formatting
    assert_same_representation wrap("return a+b;"), wrap("return   a + b ;")
    refute_same_representation wrap("return (a + b) * a;"), wrap("return a + b * a;")
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation wrap("int total = a + b;\nreturn total;"), wrap("int sum = a + b;\nreturn sum;")
    assert_same_representation "function add(int x) returns int { return x; }\nfunction g() returns int { return add(1); }",
      "function plus(int y) returns int { return y; }\nfunction g() returns int { return plus(1); }"
    assert_same_representation "type P record {| int x; |};\nfunction f(P p) { }", "type Q record {| int x; |};\nfunction f(Q q) { }"
  end

  def test_lambda_parameters_are_renamed
    assert_same_representation wrap("var g = (m, n) => m + n;\nreturn g(a, b);"), wrap("var h = (p, q) => p + q;\nreturn h(a, b);")
  end

  def test_record_fields_keep_their_names
    refute_same_representation "type P record {| int x; |};", "type P record {| int y; |};"
  end

  def test_library_calls_are_kept
    refute_same_representation wrap("io:println(a);"), wrap("io:print(a);")
    refute_same_representation wrap("return a.length();"), wrap("return a.size();")
  end

  def test_strings_keep_their_text
    refute_same_representation wrap("string s = \"a\";"), wrap("string s = \"b\";")
  end

  def test_string_templates_are_their_text
    assert_same_representation wrap("string s = string `Hello, ${a}!`;"), wrap("string t = string `Hello, ${a}!`;")
    refute_same_representation wrap("string s = string `Hello, ${a}!`;"), wrap("string s = string `Hi, ${a}!`;")
    refute_same_representation wrap("string s = string `a`;"), wrap("string s = \"a\";")
  end

  def test_quoted_names_are_names
    assert_same_representation wrap("int 'limit = 1;\nreturn 'limit;"), wrap("int total = 1;\nreturn total;")
  end

  def test_imports_are_dropped
    assert_same_representation "import ballerina/io;\nimport ballerina/http as h;\npublic function main() { }",
      "public function main() { }"
    refute_same_representation "import ballerina/io;\npublic function main() { io:println(1); }",
      "import ballerina/log;\npublic function main() { log:println(1); }"
  end

  def test_floats_are_their_values
    assert_same_representation wrap("float x = 1.50;"), wrap("float x = 1.5;")
    refute_same_representation wrap("decimal x = 1.50d;"), wrap("decimal x = 1.5d;")
    refute_same_representation wrap("float x = 1.5;"), wrap("float x = 1.6;")
  end
end
