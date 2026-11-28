require_relative "stage_helper"

# Tests Wren's Normalise stage, through Inspector as a whole.
class WrenNormaliseTest < InspectorTest
  include WrenStages

  track "wren"

  def test_a_body_without_braces_gets_them
    assert_same_representation "if (a) { b() }", "if (a) b()"
    assert_same_representation "while (a) { b() }", "while (a) b()"
    assert_same_representation "for (i in a) { b(i) }", "for (i in a) b(i)"
    assert_same_representation "if (a) { b() } else { c() }", "if (a) b() else c()"
    assert_same_representation "if (a) b() else { if (c) d() }", "if (a) b() else if (c) d()"
    refute_same_representation "if (a) { b() }", "if (a) {\nb()\nc()\n}"
  end
end
