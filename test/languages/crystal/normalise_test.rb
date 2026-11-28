require_relative "stage_helper"

# Tests Crystal's Normalise stage, through Rosetta as a whole, because the
# names it writes are renamed afterwards.
class CrystalNormaliseTest < RosettaTest
  include CrystalStages

  track "crystal"

  def test_accessor_symbols_are_names
    code = "class A\n  getter :%s\n  def initialize(@%s : Int32); end\n  def f\n    %s\n  end\nend\n"
    assert_same_representation format(code, "alpha", "alpha", "alpha"), format(code, "beta", "beta", "beta")
    assert_same_representation in_class("property :alpha\ndef initialize(@alpha : Int32); end"),
      in_class("property alpha\ndef initialize(@alpha : Int32); end")
    assert_same_representation in_class("@@alpha = 1\nclass_getter :alpha"), in_class("@@alpha = 1\nclass_getter alpha")
  end

  def test_other_symbols_stay_symbols
    refute_same_representation in_class("x = :alpha"), in_class("x = alpha")
  end
end
