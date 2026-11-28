require_relative "stage_helper"

# Checks F#'s declarations of which nodes are names and which nodes define
# them (see fsharp/spec.rb), through the engine's renaming.
class FSharpNamesTest < Minitest::Test
  include FSharpStages

  def test_renames_modules_and_namespaces
    assert_equal %w[A B C x], renamed("namespace A.B\nmodule C =\n    let x = 1")
  end

  def test_renames_functions_values_parameters_and_pattern_variables
    source = "module M\nlet f a (b: int) (c, d) =\n    let e = a\n    let g = fun h -> h\n    match b with\n    " \
             "| Some i -> i\n    | j :: k as l -> j\n    | :? string as m -> 0\n    | _ -> 0"
    assert_equal %w[M a b c d e f g h i j k l m], renamed(source)
  end

  def test_renames_loop_and_use_variables
    source = "module M\nlet f xs =\n    for i in xs do ()\n    for j = 0 to 3 do ()\n    use r = xs\n    ()"
    assert_equal %w[M f i j r xs], renamed(source)
  end

  def test_renames_types_cases_fields_and_members
    source = "module M\ntype R = { Name: string }\ntype U =\n    | Circle of radius: float\ntype E = Red = 1\n" \
             "type C(n: int) =\n    member this.Area = n\n    abstract member Size: int\nexception Oops of string"
    assert_equal %w[Area C Circle E M Name Oops R Red Size U n radius this], renamed(source)
  end

  def test_renames_active_patterns_and_type_variables
    assert_equal %w[Even M Odd a f n x], renamed("module M\nlet (|Even|Odd|) n = if n % 2 = 0 then Even else Odd\nlet f (x: 'a) = x")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("module M\nlet sum xs = List.sum xs\nlet total = sum [1]")
    assert(marks.select { |text, _| %w[sum xs].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[M f x], renamed("module M\nlet f x = List.map string x |> Some")
    assert_equal %w[M f o], renamed("module M\nlet f o = match o with\n    | None -> 0\n    | _ -> 1")
    assert_equal %w[Go M], renamed("module M\ntype C() =\n    member _.Go = 1").grep_v("C")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], FSharp::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if FSharp::Representation::Spec.name?(node) }
    leaves
  end
end
