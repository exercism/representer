require_relative "stage_helper"

# Checks Lua's declarations of which nodes are names and which nodes define
# them (see lua/representation.rb), through the engine's renaming.
class LuaNamesTest < Minitest::Test
  include LuaStages

  def test_renames_variables_and_parameters
    source = "local a, b = 1, 2\nc = 3\nlocal function f(x, ...) local y = x return y end\ng = function(z) return z end"
    assert_equal %w[a b c f g x y z], renamed(source)
  end

  def test_renames_functions_and_methods_on_tables
    source = "local M = {}\nfunction M.area(w) return w end\nfunction M:size() return self.n end\nM.count = 0"
    assert_equal %w[M area count self size w], renamed(source)
  end

  def test_renames_the_fields_that_are_assigned_to
    assert_equal %w[n new o value], renamed("local function new(n) local o = {} o.value = n return o end")
  end

  def test_renames_the_names_of_table_fields
    assert_equal %w[count t], renamed("local t = { count = 0 }")
  end

  def test_keeps_keys_in_brackets
    assert_equal %w[t], renamed("local t = { [k] = 0 }")
  end

  def test_renames_the_variables_of_loops_and_labels
    source = "for i = 1, 3 do end\nfor k, v in pairs(t) do end\ngoto done\n::done::"
    assert_equal %w[done i k v], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("local function f(s) return string.upper(s):rep(2) end")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[f s upper], renamed("local function f(s) local upper = 1 return s:upper() end")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Lua::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Lua::Representation::Spec.name?(node) }
    leaves
  end
end
