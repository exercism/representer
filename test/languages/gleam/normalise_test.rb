require_relative "stage_helper"

# Tests Gleam's Normalise stage, and the imports that the engine drops,
# through Rosetta as a whole, because the names it writes are renamed
# afterwards.
class GleamNormaliseTest < RosettaTest
  include GleamStages

  track "gleam"

  def test_imports_are_dropped
    assert_same_representation "import gleam/string\nimport gleam/list\n\npub fn f() { 1 }", "pub fn f() { 1 }"
    assert_same_representation "import gleam/list.{map, filter}\npub fn f() { 1 }", "pub fn f() { 1 }"
    refute_same_representation "import gleam/string\npub fn f(x) { string.length(x) }",
      "import gleam/list\npub fn f(x) { list.length(x) }"
  end

  def test_import_aliases_are_the_names_they_stand_for
    assert_same_representation "import gleam/list as l\npub fn f() { l.length([]) }",
      "import gleam/list as m\npub fn f() { m.length([]) }"
    assert_same_representation "import gleam/list as l\npub fn f() { l.length([]) }",
      "import gleam/list\npub fn f() { list.length([]) }"
    assert_same_representation "import gleam/int.{to_string as ts}\npub fn f(x) { ts(x) }",
      "import gleam/int.{to_string}\npub fn f(x) { to_string(x) }"
    refute_same_representation "import gleam/list as l\npub fn f() { l.length([]) }",
      "import gleam/string as l\npub fn f() { l.length([]) }"
  end
end
