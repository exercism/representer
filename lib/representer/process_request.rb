module Representer
  # Handles one HTTP request from the load balancer. The request and response
  # bodies are described in README.md.
  class ProcessRequest
    include Mandate

    initialize_with :event, :context

    def call
      result = RepresentSolution.(track_slug, solution_files, exercise_files)
      respond(200, representation: result.representation, mapping: result.mapping, version: result.version)
    rescue BadRequest => e
      respond(400, error: e.message)
    rescue TooLarge => e
      respond(413, error: e.message)
    end

    private
    def respond(status, body)
      {
        statusCode: status,
        statusDescription: STATUS_DESCRIPTIONS.fetch(status),
        headers: { 'Content-Type': 'application/json' },
        isBase64Encoded: false,
        body: body.to_json
      }
    end

    STATUS_DESCRIPTIONS = { 200 => "200 OK", 400 => "400 Bad Request", 413 => "413 Payload Too Large" }.freeze
    private_constant :STATUS_DESCRIPTIONS

    def track_slug
      slug = body["track_slug"]
      raise BadRequest, "track_slug must be a string" unless slug.is_a?(String) && !slug.empty?

      slug
    end

    memoize
    def solution_files
      files("solution_files", MAX_SOLUTION_BYTES).tap do |files|
        raise BadRequest, "solution_files must not be empty" if files.empty?
      end
    end

    memoize
    def exercise_files = files("exercise_files", MAX_EXERCISE_BYTES, required: false)

    def files(key, max_bytes, required: true)
      files = body.fetch(key) { required ? nil : {} }
      unless files.is_a?(Hash) && files.all? { |name, source| name.is_a?(String) && source.is_a?(String) }
        raise BadRequest, "#{key} must be an object of filenames to file contents"
      end

      bytes = files.sum { |name, source| name.bytesize + source.bytesize }
      raise TooLarge, "#{key} hold #{bytes} bytes, and the limit is #{max_bytes}" if bytes > max_bytes

      files
    end

    memoize
    def body
      raw = event["body"].to_s
      raw = raw.unpack1("m") if event["isBase64Encoded"]
      parsed = JSON.parse(raw)
      raise BadRequest, "The body must be a JSON object" unless parsed.is_a?(Hash)

      parsed
    rescue JSON::ParserError
      raise BadRequest, "The body is not valid JSON"
    end
  end
end
