require "test_helper"

# The old zig-representer was the Exercism template: it joined the solution
# files, removed blank lines and trailing whitespace, and never changed a name.
# Its golden tests are the template's F# examples (Leap.fs), so none of them
# can be ported. Everything below is new.
class ZigTest < RepresenterTest
  track "zig"

  def wrap(body) = "pub fn f(x: u32) u32 {\n#{body}\n}\n"

  ### Formatting ###

  def test_comments_and_layout_are_ignored
    assert_same_representation "//! module\n/// doc\npub fn f() void {\n    // note\n    return;\n}\n",
      "pub fn f() void {\n\n  return;\n\n}"
  end

  def test_trailing_commas
    assert_same_representation "const a = [_]u8{ 1, 2, 3, };", "const a = [_]u8{\n    1,\n    2,\n    3\n};"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same_representation wrap("return (x + 1);"), wrap("return x + 1;")
    refute_same_representation wrap("return (x + 1) * 2;"), wrap("return x + 1 * 2;")
  end

  def test_numbers_with_underscores
    assert_same_representation wrap("return 1_000;"), wrap("return 1000;")
    refute_same_representation wrap("return 1000;"), wrap("return 100;")
  end

  def test_strings
    assert_same_representation wrap('_ = "a\\nb"; return x;'), wrap("_ = \"a\\x0Ab\"; return x;")
    assert_same_representation wrap('_ = "\\u{41}"; return x;'), wrap('_ = "A"; return x;')
    refute_same_representation wrap('_ = "a"; return x;'), wrap('_ = "b"; return x;')
    refute_same_representation wrap("_ = 'a'; return x;"), wrap("_ = 'b'; return x;")
  end

  ### Names ###

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "pub fn plus(a: u32, b: u32) u32 { return a + b; }",
      "pub fn sum(x: u32, y: u32) u32 { return x + y; }"
    assert_same_representation "const limit = 5;\nfn f() u32 { return limit; }",
      "const max_value = 5;\nfn f() u32 { return max_value; }"
    assert_same_representation wrap("var n: u32 = 0; n += x; return n;"), wrap("var total: u32 = 0; total += x; return total;")
    assert_same_representation wrap("for (0..x) |i| { _ = i; } return x;"), wrap("for (0..x) |j| { _ = j; } return x;")
    assert_same_representation wrap("const r = foo() catch |err| return err; return r;"),
      wrap("const r = foo() catch |e| return e; return r;")
    assert_same_representation wrap("outer: while (true) { break :outer; } return x;"),
      wrap("loop: while (true) { break :loop; } return x;")
  end

  def test_structs_enums_and_errors
    assert_same_representation "const P = struct { x: i32 };\nfn f(p: P) i32 { return p.x; }",
      "const Q = struct { a: i32 };\nfn f(q: Q) i32 { return q.a; }"
    assert_same_representation "const C = enum { red, blue };\nconst c = C.red;", "const D = enum { one, two };\nconst c = D.one;"
    assert_same_representation "const E = error{ Bad };\nfn f() E!void { return error.Bad; }",
      "const F = error{ Worse };\nfn f() F!void { return error.Worse; }"
    refute_same_representation "const C = enum { red, blue };\nconst c = C.red;", "const C = enum { red, blue };\nconst c = C.blue;"
  end

  def test_names_from_outside_are_kept
    refute_same_representation wrap("return x +% 1;"), wrap("return x +| 1;")
    refute_same_representation "const std = @import(\"std\");\nconst a = std.mem.eql;",
      "const std = @import(\"std\");\nconst a = std.mem.order;"
    refute_same_representation wrap("return @abs(x);"), wrap("return @min(x, 1);")
    refute_same_representation "const T = struct { fn len() u32 { return 1; } };", "const T = struct { fn count() u32 { return 1; } };"
  end

  def test_names_from_the_tests_are_kept
    tests = { "test_leap.zig" => "const leap = @import(\"leap.zig\");\ntest \"a\" { _ = leap.isLeapYear(1); }" }
    refute_same_representation "pub fn isLeapYear(y: u32) bool { return y == 1; }", "pub fn other(y: u32) bool { return y == 1; }",
      exercise_files: tests
    assert_same_representation "pub fn isLeapYear(y: u32) bool { return y == 1; }",
      "pub fn isLeapYear(z: u32) bool { return z == 1; }", exercise_files: tests
  end

  def test_the_stub_s_functions_are_kept
    stub = { "leap.zig" => "pub fn isLeapYear(year: u32) bool {\n    _ = year;\n    @compileError(\"x\");\n}\n" }
    refute_same_representation "pub fn isLeapYear(year: u32) bool { return year == 1; }",
      "pub fn other(year: u32) bool { return year == 1; }", exercise_files: stub
  end

  def test_things_that_must_stay_apart
    refute_same_representation wrap("return x + 1;"), wrap("return x - 1;")
    refute_same_representation wrap("const a = x; return a;"), wrap("var a = x; return a;")
    refute_same_representation "fn f() void {}", "pub fn f() void {}"
    refute_same_representation wrap("return x | 1;"), wrap("return x & 1;")
  end

  def test_a_syntax_error_falls_back
    assert_falls_back "fn f( void {"
  end
end
