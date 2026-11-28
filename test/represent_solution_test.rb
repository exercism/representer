require "test_helper"

class RepresentSolutionTest < Minitest::Test
  def represent(track_slug, files) = Representer::RepresentSolution.(track_slug, files)

  def test_a_solution_that_does_not_parse_gets_basics_representation_with_the_languages_version
    files = { "two_fer.rb" => "def two_fer(name\n  name # the name\nend" }
    result = represent("ruby", files)

    assert_equal "basic\ndef two_fer ( name\nname\nend", result.representation
    assert_empty result.mapping
    assert_equal Representer::Languages::Ruby::Representation::Spec.version, result.version
    assert_nil result.reason
  end

  # Every tree representation starts with "(", so the first line keeps the
  # two forms apart, even for code that Basic writes much like a tree.
  def test_basics_representation_never_equals_a_trees
    tree = represent("clojure", { "a.clj" => "(inc x)" }).representation
    basic = represent("clojure", { "a.clj" => "(inc x" }).representation

    assert tree.start_with?("(")
    assert basic.start_with?(Representer::RepresentSolution::BASIC_PREFIX)
  end

  def test_a_solution_that_nests_too_deeply_still_gets_no_representation
    result = represent("ruby", { "a.rb" => ("[" * 2_000) + ("]" * 2_000) })

    assert_nil result.representation
    assert_equal "too_deep", result.reason
  end
end
