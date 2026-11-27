require "test_helper"

class ZigTest < RepresenterTest
  track "zig"

  def wrap(body) = "pub fn f(x: u32) u32 {\n#{body}\n}\n"

  def test_comments_and_layout_are_ignored
    assert_same_representation "//! module\n/// doc\npub fn f() void {\n    // note\n    return;\n}\n",
      "pub fn f() void {\n\n  return;\n\n}"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "pub fn plus(a: u32, b: u32) u32 { return a + b; }",
      "pub fn sum(x: u32, y: u32) u32 { return x + y; }"
    assert_same_representation wrap("outer: while (true) { break :outer; } return x;"),
      wrap("loop: while (true) { break :loop; } return x;")
    assert_same_representation "const P = struct { x: i32 };\nfn f(p: P) i32 { return p.x; }",
      "const Q = struct { a: i32 };\nfn f(q: Q) i32 { return q.a; }"
    assert_same_representation "const T = struct { fn len() u32 { return 1; } };", "const T = struct { fn count() u32 { return 1; } };"
    refute_same_representation "const C = enum { red, blue };\nconst c = C.red;", "const C = enum { red, blue };\nconst c = C.blue;"
    refute_same_representation wrap("const a, const b = .{ x, 2 }; return a + b;"),
      wrap("const a, const b = .{ x, 2 }; return b + a;")
  end

  def test_names_from_outside_are_kept_if_the_solution_only_calls_them
    refute_same_representation wrap("return x +% 1;"), wrap("return x +| 1;")
    refute_same_representation "const std = @import(\"std\");\nconst a = std.mem.eql;",
      "const std = @import(\"std\");\nconst a = std.mem.order;"
    refute_same_representation wrap("return @abs(x);"), wrap("return @min(x, 1);")
  end

  def test_things_that_must_stay_apart
    refute_same_representation wrap("return x + 1;"), wrap("return x - 1;")
    refute_same_representation wrap("return x | 1;"), wrap("return x & 1;")
  end

  def test_imports_are_dropped
    assert_same_representation "const std = @import(\"std\");\nconst print = @import(\"std\").debug.print;\npub fn f() void {}",
      "pub fn f() void {}"
    assert_same_representation "pub fn f() void {\nconst m = @import(\"std\").math;\n_ = m;\n}",
      "pub fn f() void {\n_ = m;\n}"
    refute_same_representation "const std = @import(\"std\");\npub fn f() void { std.debug.print(\"a\", .{}); }",
      "const std = @import(\"std\");\npub fn f() void { std.log.info(\"a\", .{}); }"
  end

  def test_a_syntax_error_gets_a_basic_representation
    assert_basic_representation "fn f( void {"
  end
end
