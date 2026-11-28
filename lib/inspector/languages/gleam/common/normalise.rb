# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. These rules
# give one form to spellings that every output treats as the same.
module Inspector::Languages::Gleam::Common
  class Normalise < Inspector::Engine::Normalise
    def call
      super.tap do |root|
        write_each_import_alias_as_the_name_it_stands_for!(root)
      end
    end

    private
    # Write each name given with `as` in an import as the name it stands for.
    # This runs before the engine drops the imports.
    #
    # import gleam/list as l ... l.length(xs)  ->  list.length(xs)
    # import gleam/int.{to_string as ts} ... ts(x)  ->  to_string(x)
    def write_each_import_alias_as_the_name_it_stands_for!(root)
      aliases = import_aliases(root)
      return if aliases.empty?

      each_node(root) do |node, _|
        next unless ["identifier", "type_identifier"].include?(node.type) && node.leaf?

        node.text = aliases.fetch(node.text, node.text)
      end
    end

    # Map each alias to the name it stands for: the module's last part for
    # `import gleam/list as l`, and the name for `import gleam/int.{to_string as ts}`.
    def import_aliases(root)
      find_all(root, "(import) @import").each_with_object({}) do |match, aliases|
        import = match.node
        aliases[import[:alias].text] = import[:module].text.split("/").last if import[:alias]
        find_all(import, "(unqualified_import name: (_) @name alias: (_) @alias)").each do |pair|
          aliases[pair[:alias].text] = pair[:name].text
        end
      end
    end
  end
end
