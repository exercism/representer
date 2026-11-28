require "test_helper"
require "golden"

# Runs every track over its golden solutions and its fixtures, with simple
# changes to each file, and checks two things:
#
# - The request never raises. It returns a representation, or a 200 with a
#   reason the website knows.
# - The same request gets the same response twice.
#
# By default it takes one golden solution and one fixture per track, picked
# with a fixed seed. To take more, set FUZZ_SAMPLE, and to limit it to some
# tracks, set FUZZ_TRACKS:
#
#   FUZZ_SAMPLE=50 FUZZ_TRACKS=go,rust bundle exec ruby -Itest test/fuzz_test.rb
class FuzzTest < Minitest::Test
  REASONS = %w[parse_error too_deep too_large no_source_files].freeze
  SAMPLE = Integer(ENV.fetch("FUZZ_SAMPLE", "1"))
  SEED = 20_261_126

  # This text stands for a byte that isn't valid UTF-8. The request's JSON
  # gets the raw byte in its place, which the JSON parser passes through, so
  # Rosetta receives an invalid string.
  BAD_CHARACTER = "\u0001INVALID\u0001".freeze

  # An editor chooses these, not the student, so they must not change the
  # response. Each one replaces the source's own line endings or mark, if it
  # has any.
  SAME_AS_UNCHANGED = %w[crlf bom].freeze

  MUTATIONS = {
    "unchanged" => ->(source, _random) { source },
    "no_line_endings" => ->(source, _random) { source.delete("\n") },
    "double_line_endings" => ->(source, _random) { source.gsub("\n", "\n\n") },
    "crlf" => ->(source, _random) { source.gsub(/\r?\n/, "\r\n") },
    "cr_only" => ->(source, _random) { source.tr("\n", "\r") },
    "bom" => ->(source, _random) { "﻿#{source.delete_prefix('﻿')}" },
    "nul" => ->(source, random) { source.dup.insert(random.rand(source.size + 1), "\0") },
    "invalid_utf8" => ->(source, random) { source.dup.insert(random.rand(source.size + 1), BAD_CHARACTER) },
    "truncated" => ->(source, random) { source[0, random.rand(source.size + 1)] },
    "truncated_again" => ->(source, random) { source[0, random.rand(source.size + 1)] },
    "line_dropped" => ->(source, random) { source.lines.tap { |lines| lines.delete_at(random.rand(lines.size + 1)) }.join },
    "line_doubled" => lambda { |source, random|
      source.lines.tap { |lines| lines.insert(random.rand(lines.size + 1), *lines.sample(1, random:)) }.join
    },
    "doubled" => ->(source, _random) { "#{source}\n#{source}" },
    "empty" => ->(_source, _random) { "" },
    "whitespace" => ->(_source, _random) { " \n\t\n" }
  }.freeze

  def self.cases(track)
    random = Random.new(SEED)
    golden = Golden.tracks.include?(track) ? Golden.solutions(track) : []
    golden = golden.sample(SAMPLE, random:)
    solutions = golden.map { |solution| [solution.id, solution.files, Golden.exercise_files(track, solution.exercise)] }

    fixtures = fixture_dirs(track)
    fixtures = fixtures.sample(SAMPLE, random:)
    solutions + fixtures.map { |dir| ["fixture #{File.basename(dir)}", fixture_files(dir), {}] }
  end

  def self.fixture_dirs(track)
    root = File.expand_path("fixtures", __dir__)
    [track, "#{track}-multi-file"].flat_map { |name| Dir.glob(File.join(root, name, "*")).sort }.select { |dir| File.directory?(dir) }
  end

  def self.fixture_files(dir)
    Golden.read_files(dir).reject { |path, _| path.start_with?("expected_", "equivalent") }
  end

  def self.tracks
    all = (Golden.tracks + Rosetta::Languages.registry.keys).uniq.sort
    ENV["FUZZ_TRACKS"] ? all & ENV["FUZZ_TRACKS"].split(",") : all
  end

  tracks.each do |track|
    define_method("test_#{track.tr('-', '_')}_never_raises_and_is_deterministic") do
      random = Random.new(SEED)
      self.class.cases(track).each do |name, files, exercise_files|
        responses = MUTATIONS.to_h do |mutation, change|
          mutated = files.transform_values { |source| change.(source, random) }
          [mutation, check(track, "#{name} (#{mutation})", mutated, exercise_files)]
        end
        SAME_AS_UNCHANGED.each do |mutation|
          assert_equal responses["unchanged"], responses[mutation], "#{track} #{name} changed with #{mutation}"
        end
        check(track, "#{name} (many copies)", many_copies(files), exercise_files)
      end
    end
  end

  private
  # The solution's files, each copied under 40 more names.
  def many_copies(files)
    files.flat_map do |path, source|
      [[path, source]] + Array.new(40) { |index| ["copy#{index}/#{path}", source] }
    end.to_h
  end

  def check(track, name, solution_files, exercise_files)
    first = respond(track, name, solution_files, exercise_files)
    second = respond(track, name, solution_files, exercise_files)

    assert_equal 200, first[:statusCode], "#{track} #{name}: #{first[:body]}"
    output = JSON.parse(first[:body])["representation"]
    assert output["representation"] || REASONS.include?(output["error"]), "#{track} #{name}: #{first[:body]}"
    assert_equal first[:body], second[:body], "#{track} #{name} got a different response the second time"
    first[:body]
  end

  def respond(track, name, solution_files, exercise_files)
    body = { track_slug: track, exercise_slug: "fuzz", outputs: Rosetta::Generate::OUTPUTS, solution_files:,
             exercise_files: }.to_json
    body = body.b.gsub(BAD_CHARACTER.to_json[1..-2].b, "\xFF".b)
    Rosetta.process(event: { "body" => body }, context: {})
  rescue StandardError, SystemStackError => e
    flunk "#{track} #{name} raised #{e.class}: #{e.message.lines.first}\n#{e.backtrace.first(5).join("\n")}"
  end
end
