require_relative "stage_helper"

# Tests Elm's Normalise stage, and the engine's dropping of Elm's imports,
# through the whole representer.
class ElmNormaliseTest < RepresenterTest
  include ElmStages

  track "elm"

  def test_imports_are_dropped
    assert_same_representation "module M exposing (..)\n\nimport Dict exposing (Dict)\nimport List as L\n\nf =\n    1\n",
      "module M exposing (..)\n\nf =\n    1\n"
    refute_same_representation "module M exposing (f)\n\nimport Array\n\nf =\n    Array.map\n",
      "module M exposing (f)\n\nimport List\n\nf =\n    List.map\n"
  end

  def test_the_list_of_what_the_module_exposes_is_dropped
    assert_same_representation "module M exposing (f)\n\nf x =\n    x\n", "module M exposing (..)\n\nf x =\n    x\n"
    assert_same_representation "module M exposing (a, b)\n\na =\n    1\n\nb =\n    2\n",
      "module M exposing (b, a)\n\na =\n    1\n\nb =\n    2\n"
  end
end
