require_relative "stage_helper"

# Tests Factor's Normalise stage, through the whole representer.
class FactorNormaliseTest < RepresenterTest
  include FactorStages

  track "factor"

  def test_using_and_use_are_dropped
    assert_same_representation "USING: kernel math\n  sequences ;\nUSE: io\nIN: a\n: f ( x -- y ) 1 + ;", "IN: a\n: f ( x -- y ) 1 + ;"
  end
end
