require_relative "stage_helper"

# Checks Vimscript's declarations of which nodes are names and which nodes
# define them (see vimscript/representation/spec.rb), through the engine's
# renaming.
class VimscriptNamesTest < Minitest::Test
  include VimscriptStages

  def test_renames_functions_parameters_and_variables
    source = "function! Response(remark) abort\n  let l:answer = a:remark\n  return answer\nendfunction\n"
    assert_equal %w[Response answer remark], renamed(source)
  end

  def test_renames_loop_variables_list_targets_lambdas_and_defaults
    source = "function! F(list, step = 1)\n  for [k, v] in items(a:list)\n  endfor\n" \
             "  let [first; rest] = a:list\n  return map(rest, {i, x -> x + a:step})\nendfunction\n"
    assert_equal %w[F first i k list rest step v x], renamed(source)
  end

  def test_renames_script_variables_and_dictionary_functions
    source = "let s:stack = {}\nfunction! s:stack.Push(item) dict\n  let self.top = a:item\nendfunction\n"
    assert_equal %w[Push item stack top], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "function! F(list)\n  return map(copy(a:list), {_, val -> toupper(v:val)})\nendfunction\n"
    assert_equal %w[F _ list val], renamed(source)
  end

  def test_keeps_vims_own_variables
    source = "function! F(key)\n  return filter(a:key, 'v:key')\nendfunction\nlet x = v:key\n"
    assert_equal %w[F key x], renamed(source)
    assert_includes write(prepare_and_rename(source)), "v:key"
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    leaves = []
    prepare_and_rename(source).each_descendant do |node|
      leaves << node.text if Vimscript::Representation::Spec.name?(node) && node.renamed
    end
    leaves.uniq.sort
  end

  def prepare_and_rename(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Vimscript::Representation::Spec)
    tree
  end
end
