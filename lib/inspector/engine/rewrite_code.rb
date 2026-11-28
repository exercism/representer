module Inspector::Engine
  # Turns each piece of code that matches the code pattern into the
  # replacement,
  # for a Normalise stage's `rewrite` verb. It works from the leaves up, and
  # each placeholder in the replacement becomes a copy of its match.
  #
  # With scopes, it only rewrites code inside a node that matches one of
  # the scope patterns, and a word in both patterns must match the same
  # code. So the pattern `{{type}}.{{name}}` with the scope
  # `class {{type}} { {{...}} }` only matches `Counter.Start` inside the class
  # `Counter`, and leaves `Math.Max` alone.
  class RewriteCode
    include Mandate
    include TreeHelpers

    initialize_with :tree, :code, :replacement, scopes: []

    # A pattern with some of its words already bound, for TreeHelpers.
    Bound = Struct.new(:pattern, :bindings) do
      def match(node) = pattern.match(node, bindings)
    end

    def call
      return rewrite(tree, code) if scopes.empty?

      scopes.each do |scope|
        find_all(tree, scope).each { |match| rewrite(match.node, Bound.new(code, match.captures)) }
      end
      tree
    end

    private
    def rewrite(root, matcher) = transform(root, matcher) { |match| replacement.build(match.captures) }
  end
end
