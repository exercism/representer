# docs/dsl.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
module Representer::Languages::Crystal::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        write_accessor_symbols_as_names!(root)
      end
    end

    private
    # Write each symbol given to `getter`, `setter` or `property` (or their
    # `class_` forms) as a name, because the macro defines the same method
    # either way, and the name can then be renamed.
    # getter :count  ->  getter count
    def write_accessor_symbols_as_names!(root)
      pattern = '(call !receiver method: (identifier /\A(class_)?(property|getter|setter)[?!]?\z/) ' \
                'arguments: (argument_list (symbol)* @symbols))'
      transform(root, pattern) do |match|
        symbols = Array(match[:symbols]).select { |symbol| symbol.children.map(&:type) == ["literal_content"] }
        next nil if symbols.empty?

        arguments = match.node[:arguments]
        symbols.each { |symbol| arguments.replace_child(symbol, leaf(:identifier, symbol.children.first.text)) }
        match.node
      end
    end
  end
end
