require_relative "stage_helper"

# Checks WebAssembly's declarations of which nodes are names and which nodes
# define them (see wasm/representation.rb), through the engine's renaming.
class WasmNamesTest < Minitest::Test
  include WasmStages

  def test_renames_modules_types_and_the_fields_of_a_module
    source = "(module $m (type $t (func)) (type $s (struct (field $x i32))) (func $f) (global $g i32 (i32.const 0)) " \
             "(memory $mem 1) (table $tab 1 funcref) (data $d (i32.const 0) \"a\") (elem $e func $f) (tag $err))"
    assert_equal %w[d e err f g m mem s t tab x], renamed(source)
  end

  def test_renames_the_names_of_imports
    source = "(module (import \"env\" \"f\" (func $f)) (import \"env\" \"g\" (global $g i32)) " \
             "(import \"env\" \"mem\" (memory $mem 1)) (import \"env\" \"tab\" (table $tab 1 funcref)))"
    assert_equal %w[f g mem tab], renamed(source)
  end

  def test_renames_parameters_locals_and_labels
    source = "(module (func (param $a i32) (local $b i32) (block $c (loop $d (br $d))) (if $e (local.get $a) (then))))"
    assert_equal %w[a b c d e], renamed(source)
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("(module (global $x (mut i32) (i32.const 0)) (func $f (global.set $x (i32.const 1)) (call $f)))")
    assert marks.all?(&:last)
    assert_equal 4, marks.size
  end

  def test_keeps_the_names_of_exports_and_imports
    source = "(module (import \"env\" \"log\" (func $log)) (func (export \"run\") (call $log)))"
    assert_equal ["log"], renamed(source)
    assert_includes write(prepare(source)), "\"run\""
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's name, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Wasm::Representation::Spec)
    leaves = []
    tree.each_descendant do |node|
      leaves << [Wasm::Representation::Spec.name_text(node), node.renamed] if Wasm::Representation::Spec.name?(node)
    end
    leaves
  end
end
