require "test_helper"

class ProcessRequestTest < Minitest::Test
  def request(body = nil, encoded: false, **fields)
    body ||= fields
    raw = body.is_a?(String) ? body : body.to_json
    event = { "body" => encoded ? [raw].pack("m0") : raw, "isBase64Encoded" => encoded }
    Representer.process(event:, context: {})
  end

  def test_represents_a_solution
    response = request(track_slug: "ruby", exercise_slug: "two-fer",
      solution_files: { "two_fer.rb" => "def two_fer(name) = name" },
      exercise_files: { "two_fer_test.rb" => "two_fer('x')", ".meta/config.json" => "{}" })

    assert_equal 200, response[:statusCode]
    body = JSON.parse(response[:body])
    assert_equal({ "PLACEHOLDER_1" => "name" }, body["mapping"])
    assert_equal Representer::Languages::Ruby.version, body["version"]
    assert_includes body["representation"], "two_fer"
  end

  def test_reads_base64_bodies
    response = request({ track_slug: "ruby", solution_files: { "a.rb" => "x = 1" } }, encoded: true)
    assert_equal 200, response[:statusCode]
  end

  def test_unknown_tracks_get_basic
    body = JSON.parse(request(track_slug: "cobol", solution_files: { "a.cob" => "DISPLAY 'HI'." })[:body])
    assert_equal Representer::Languages::Basic::VERSION, body["version"]
  end

  def test_bad_requests
    assert_equal 400, request("not json")[:statusCode]
    assert_equal 400, request([1])[:statusCode]
    assert_equal 400, request(solution_files: { "a.rb" => "x" })[:statusCode]
    assert_equal 400, request(track_slug: "ruby")[:statusCode]
    assert_equal 400, request(track_slug: "ruby", solution_files: {})[:statusCode]
    assert_equal 400, request(track_slug: "ruby", solution_files: { "a.rb" => 1 })[:statusCode]
  end

  def test_solutions_with_syntax_errors
    response = request(track_slug: "ruby", solution_files: { "a.rb" => "def x(" })
    assert_equal 200, response[:statusCode]
    assert_equal({ "representation" => nil, "mapping" => {}, "version" => Representer::Languages::Ruby.version,
                   "reason" => "parse_error" }, JSON.parse(response[:body]))
  end

  def test_represented_solutions_have_no_reason
    body = JSON.parse(request(track_slug: "ruby", solution_files: { "a.rb" => "x = 1" })[:body])
    refute body.key?("reason")
  end

  def test_solutions_over_the_limit
    big = "x" * (Representer::MAX_SOLUTION_BYTES + 1)
    %w[ruby cobol].each do |track_slug|
      response = request(track_slug:, solution_files: { "a" => big })
      assert_equal 200, response[:statusCode]
      body = JSON.parse(response[:body])
      assert_nil body["representation"]
      assert_equal "too_large", body["reason"]
      assert_equal Representer::Languages.for(track_slug).version, body["version"]
    end
  end

  def test_exercise_files_have_their_own_limit
    tests = "x" * (Representer::MAX_SOLUTION_BYTES + 1)
    body = JSON.parse(request(track_slug: "ruby", solution_files: { "a.rb" => "x" }, exercise_files: { "t.rb" => tests })[:body])
    refute_nil body["representation"]

    tests = "x" * (Representer::MAX_EXERCISE_BYTES + 1)
    body = JSON.parse(request(track_slug: "ruby", solution_files: { "a.rb" => "x" }, exercise_files: { "t.rb" => tests })[:body])
    assert_equal "too_large", body["reason"]
  end
end
