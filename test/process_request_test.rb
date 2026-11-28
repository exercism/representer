require "test_helper"

class ProcessRequestTest < Minitest::Test
  def request(body = nil, encoded: false, **fields)
    body ||= { outputs: ["representation"], **fields }
    raw = body.is_a?(String) ? body : body.to_json
    event = { "body" => encoded ? [raw].pack("m0") : raw, "isBase64Encoded" => encoded }
    Rosetta.process(event:, context: {})
  end

  def test_represents_a_solution
    response = request(track_slug: "ruby", exercise_slug: "two-fer",
      solution_files: { "two_fer.rb" => "def two_fer(who) = who" },
      exercise_files: { "two_fer_test.rb" => "two_fer('x')", ".meta/config.json" => "{}" })

    assert_equal 200, response[:statusCode]
    body = JSON.parse(response[:body])
    assert_equal ["representation"], body.keys
    assert_equal({ "PLACEHOLDER_1" => "two_fer", "PLACEHOLDER_2" => "who" }, body["representation"]["mapping"])
    assert_equal Rosetta::Languages::Ruby::Representation::Spec.version, body["representation"]["version"]
  end

  def test_returns_each_output_asked_for
    body = JSON.parse(request(track_slug: "ruby", outputs: %w[analysis representation],
      solution_files: { "a.rb" => "x = 1" })[:body])
    assert_equal %w[analysis representation], body.keys
    assert_equal({ "comments" => [], "version" => Rosetta::Languages::Ruby::Analysis::Spec.version }, body["analysis"])
    refute_nil body["representation"]["representation"]
  end

  def test_returns_the_snippet_and_its_version
    body = JSON.parse(request(track_slug: "ruby", outputs: ["snippet"],
      solution_files: { "a.rb" => "require 'set'\n# A comment\nx = 1\n" })[:body])
    assert_equal({ "snippet" => "x = 1\n", "version" => Rosetta::Languages::Ruby::Snippet::Spec.version }, body["snippet"])
  end

  # Almost every track has a language of its own, so the tests of Basic use
  # a track that Rosetta doesn't know.
  def test_tracks_with_no_snippet_of_their_own_get_the_basic_one
    body = JSON.parse(request(track_slug: "unknown", outputs: ["snippet"],
      solution_files: { "a.src" => "       DISPLAY 'HI'.\n" })[:body])
    assert_equal({ "snippet" => "       DISPLAY 'HI'.\n", "version" => Rosetta::Languages::Basic::Snippet::Spec.version },
      body["snippet"])
  end

  def test_a_solution_that_cant_be_represented_still_gets_a_snippet
    code = ("[" * 2_000) + ("]" * 2_000)
    body = JSON.parse(request(track_slug: "ruby", outputs: %w[representation snippet], solution_files: { "a.rb" => code })[:body])
    assert_equal "too_deep", body["representation"]["error"]
    assert body["snippet"]["snippet"].start_with?("[[[")
  end

  def test_requests_need_outputs
    [nil, [], ["summary"], "representation", [1]].each do |outputs|
      response = request({ track_slug: "ruby", outputs:, solution_files: { "a.rb" => "x" } })
      assert_equal 400, response[:statusCode], outputs.inspect
      assert_includes JSON.parse(response[:body])["error"], "outputs must list"
    end
  end

  def test_reads_base64_bodies
    response = request({ track_slug: "ruby", outputs: ["representation"], solution_files: { "a.rb" => "x = 1" } },
      encoded: true)
    assert_equal 200, response[:statusCode]
  end

  def test_unknown_tracks_get_basic
    body = JSON.parse(request(track_slug: "unknown", solution_files: { "a.src" => "DISPLAY 'HI'." })[:body])
    assert_equal Rosetta::Languages::Basic::VERSION, body["representation"]["version"]
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
    assert_equal({ "representation" => { "representation" => "basic\ndef x (", "mapping" => {},
                                         "version" => Rosetta::Languages::Ruby::Representation::Spec.version } },
      JSON.parse(response[:body]))
  end

  def test_represented_solutions_have_no_error
    body = JSON.parse(request(track_slug: "ruby", solution_files: { "a.rb" => "x = 1" })[:body])
    refute body["representation"].key?("error")
  end

  def test_solutions_over_the_limit
    big = "x" * (Rosetta::MAX_SOLUTION_BYTES + 1)
    %w[ruby unknown].each do |track_slug|
      response = request(track_slug:, solution_files: { "a" => big })
      assert_equal 200, response[:statusCode]
      output = JSON.parse(response[:body])["representation"]
      assert_equal "too_large", output["error"]
      assert_equal Rosetta::Languages.for(track_slug).version, output["version"]
    end
  end

  def test_exercise_files_have_their_own_limit
    tests = "x" * (Rosetta::MAX_SOLUTION_BYTES + 1)
    body = JSON.parse(request(track_slug: "ruby", solution_files: { "a.rb" => "x" }, exercise_files: { "t.rb" => tests })[:body])
    refute_nil body["representation"]["representation"]

    tests = "x" * (Rosetta::MAX_EXERCISE_BYTES + 1)
    body = JSON.parse(request(track_slug: "ruby", solution_files: { "a.rb" => "x" }, exercise_files: { "t.rb" => tests })[:body])
    assert_equal "too_large", body["representation"]["error"]
  end

  # A language with a bug in a stage.
  module Raising
    module Common
      class Spec < Rosetta::Engine::Language
        grammar "ruby"
        extensions ".rb"
      end

      class Normalise < Rosetta::Engine::Stage
        def call = tree.nonexistent
      end
    end

    module Representation
      class Spec < Rosetta::Engine::Representation
        version 2
      end
    end
  end

  def test_an_error_in_a_rule_makes_the_solution_unrepresentable
    Rosetta::Languages.register("raising", Raising::Common::Spec)
    body = nil
    _, log = capture_io do
      body = JSON.parse(request(track_slug: "raising", exercise_slug: "leap", solution_files: { "a.rb" => "x = 1" })[:body])
    end
    assert_equal({ "error" => "internal_error", "message" => "One of Rosetta's rules raised an error",
                   "version" => 2 }, body["representation"])
    assert_includes log, "raising/leap: NoMethodError"
  ensure
    Rosetta::Languages.registry.delete("raising")
  end
end
