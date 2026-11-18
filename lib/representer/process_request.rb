module Representer
  # Handles one HTTP request from the load balancer. The request and response
  # bodies are described in README.md.
  class ProcessRequest
    include Mandate

    initialize_with :event, :context

    def call
      respond(200, represent)
    rescue BadRequest => e
      respond(400, error: e.message)
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

    STATUS_DESCRIPTIONS = { 200 => "200 OK", 400 => "400 Bad Request" }.freeze
    private_constant :STATUS_DESCRIPTIONS

    # Exercise files over their limit make the solution too large too, as the
    # whole request has to fit under the load balancer's limit.
    def represent
      if bytes(exercise_files) > MAX_EXERCISE_BYTES
        return { representation: nil, mapping: {}, version: Languages.for(track_slug).version, reason: "too_large" }
      end

      result = RepresentSolution.(track_slug, solution_files, exercise_files)
      body = { representation: result.representation, mapping: result.mapping, version: result.version }
      result.reason ? body.merge(reason: result.reason) : body
    end

    def track_slug
      slug = body["track_slug"]
      raise BadRequest, "track_slug must be a string" unless slug.is_a?(String) && !slug.empty?

      slug
    end

    memoize
    def solution_files
      files("solution_files").tap do |files|
        raise BadRequest, "solution_files must not be empty" if files.empty?
      end
    end

    memoize
    def exercise_files = files("exercise_files", required: false)

    def files(key, required: true)
      files = body.fetch(key) { required ? nil : {} }
      unless files.is_a?(Hash) && files.all? { |name, source| name.is_a?(String) && source.is_a?(String) }
        raise BadRequest, "#{key} must be an object of filenames to file contents"
      end

      files
    end

    def bytes(files) = files.sum { |name, source| name.bytesize + source.bytesize }

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
