require "test_helper"
require "golden"

# Checks the golden data in test/golden/ (see test/golden/README.md). For
# every track there are two tests:
#
# - Every solution's representation is the one in its representation.txt.
# - The groups that the representations make are the production groups,
#   apart from exactly the differences listed in differences.yml.
#
# After a deliberate change, run bin/regenerate-golden for the track and
# review the diff.
class GoldenTest < Minitest::Test
  def self.texts(track)
    @texts ||= {}
    @texts[track] ||= Golden.solutions(track).to_h { |solution| [solution.id, Golden.representation(solution)] }
  end

  Golden.tracks.each do |track|
    slug = track.tr("-", "_")

    define_method("test_#{slug}_representations_stay_the_same") do
      solutions = Golden.solutions(track)
      changed = solutions.reject { |solution| solution.recorded_representation == self.class.texts(track)[solution.id] }

      assert_empty changed.map(&:id),
        "#{changed.size} of #{solutions.size} #{track} representations changed. " \
        "If the change is deliberate, run bin/regenerate-golden #{track} and review the diff."
    end

    define_method("test_#{slug}_groups_stay_the_same") do
      found = Golden.differences(track, self.class.texts(track)).map { |difference| Golden.key(difference) }
      listed = Golden.recorded_differences(track).map { |difference| Golden.key(difference) }

      assert_empty found - listed, "These #{track} differences from the production groups aren't in differences.yml"
      assert_empty listed - found, "These #{track} differences in differences.yml no longer happen"
    end
  end
end
