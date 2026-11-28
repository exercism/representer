module Rosetta
  # Handles one HTTP request from the load balancer. The request and response
  # bodies are described in README.md.
  class ProcessRequest
    include Mandate

    initialize_with :event, :context

    def call
      respond(200, Generate.(track_slug, solution_files, outputs:, exercise_files:, exercise_slug: body["exercise_slug"]))
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

    def track_slug
      slug = body["track_slug"]
      raise BadRequest, "track_slug must be a string" unless slug.is_a?(String) && !slug.empty?

      slug
    end

    # The outputs to generate, such as ["representation", "snippet"] (see
    # Generate).
    def outputs
      outputs = body["outputs"]
      names = Generate::OUTPUTS.map(&:to_s)
      unless outputs.is_a?(Array) && outputs.any? && outputs.all? { |output| names.include?(output) }
        raise BadRequest, "outputs must list one or more of: #{names.join(', ')}"
      end

      outputs.map(&:to_sym)
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
