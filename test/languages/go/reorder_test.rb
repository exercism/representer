require_relative "stage_helper"

# Tests Go's Reorder stage, through the whole representer, because it
# sorts by the code with the renamed names left out.
class GoReorderTest < RepresenterTest
  include GoStages

  track "go"

  def test_the_order_of_top_level_declarations_makes_no_difference
    assert_same_representation "package p\n\nfunc A() int { return 1 }\n\ntype T int\n\nconst C = 1\n\nvar V = 2\n",
      "package p\n\nvar V = 2\n\nconst C = 1\n\ntype T int\n\nfunc A() int { return 1 }\n"
    assert_same_representation "package p\n\nfunc A() int { return 1 }\n\nfunc B() int { x := 1; return x }\n",
      "package p\n\nfunc B() int { x := 1; return x }\n\nfunc A() int { return 1 }\n"
  end

  def test_the_order_of_statements_in_a_function_stays
    refute_same_representation in_function("f(1)\ng(2)"), in_function("g(2)\nf(1)")
  end
end
