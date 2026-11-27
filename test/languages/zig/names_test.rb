require_relative "stage_helper"

# Checks Zig's declarations of which nodes are names and which nodes define
# them (see zig/representation.rb), through the engine's renaming.
class ZigNamesTest < Minitest::Test
  include ZigStages

  def test_renames_functions_constants_variables_and_parameters
    source = "const limit = 5;\npub fn plus(a: u32, b: u32) u32 {\nvar total: u32 = a;\ntotal += b;\nreturn total + limit;\n}\n"
    assert_equal %w[a b limit plus total], renamed(source)
  end

  def test_renames_destructured_names
    assert_equal %w[a b f x], renamed(in_function("const a, var b = .{ x, 2 };\nb += a;\nreturn b;"))
  end

  def test_renames_the_variables_of_payloads_and_labels
    source = in_function("for (0..x) |i, j| { _ = i + j; }\n" \
                         "const r = g() catch |err| return err;\n" \
                         "if (h()) |v| { _ = v; }\n" \
                         "outer: while (true) { break :outer; }\n" \
                         "return r;")
    assert_equal %w[err f i j outer r v x], renamed(source)
  end

  def test_renames_fields_enum_values_and_errors
    source = "const P = struct { x: i32 };\nconst C = enum { red, blue };\nconst E = error{ Bad };\n" \
             "fn f(p: P) E!i32 { if (p.x == 0) return error.Bad; _ = C.red; return p.x; }\n"
    assert_equal %w[Bad C E P blue f p red x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "const std = @import(\"std\");\npub fn f(s: []const u8) bool { return std.mem.eql(u8, s, \"a\"); }\n"
    assert_equal %w[f s], renamed(source)
  end

  def test_keeps_the_discard
    assert_equal %w[f i x], renamed(in_function("for (0..x) |i, _| { _ = i; }\nreturn x;"))
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Zig::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Zig::Representation.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
