require_relative "stage_helper"

# Tests Ballerina's representation Normalise stage, which drops imports.
class BallerinaNormaliseTest < Minitest::Test
  include BallerinaStages

  def test_drops_imports
    assert_same "import ballerina/io;\nimport ballerina/http as h;\npublic function main() { }", "public function main() { }"
    refute_same "import ballerina/io;\npublic function main() { io:println(1); }",
      "import ballerina/log;\npublic function main() { log:println(1); }"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
