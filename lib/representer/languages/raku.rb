module Representer
  module Languages
    # The old raku-representer printed Rakudo's `.AST.raku` and replaced every
    # name in it with a placeholder. It has two golden tests (whitespace and
    # comments), both of which give the same output. This class reads the code
    # with tree-sitter, so it needs no Rakudo, and renames only the names that
    # the student defines.
    class Raku < Language
      tracks "raku"
      version 2
      grammar "raku"
      extensions ".rakumod", ".raku", ".rakutest", ".pm6", ".p6"

      # A variable's name includes its sigil (`$count`, `@items`), so `$count`
      # and a sub called `count` stay apart. A variable's type says its sigil,
      # because a placeholder doesn't. The rewrites below give a variable that
      # the student defines the `local_` type, and a sub, method or class that
      # the student defines the `definition` type.
      SIGILS = { "$" => "scalar", "@" => "array", "%" => "hash", "&" => "code" }.freeze
      VARIABLES = SIGILS.values.freeze
      names :identifier, *VARIABLES, *VARIABLES.map { |type| :"local_#{type}" }, :definition

      ### Drop ###

      comments "[(comment) (pod)]"
      drop_tokens ";"

      ### Snippet ###

      # The snippet skips `use` statements and `unit module` at the top of the file.
      snippet_header "(use_statement)", '(unit_declaration "module")', '";"'

      ### Rewrite ###

      # (a + b) is a + b, and an expression statement is its expression: the
      # tree's shape already shows both.
      unwrap :parenthesized_expression, :expression_statement

      # 1_000 is 1000.
      rewrite "(integer /_/) @number" do |match|
        leaf(:integer, match[:number].text.delete("_"))
      end

      # 'a', ‘a’ and "a" are the same string. Strings with escapes or
      # interpolation keep their structure, unless every escape is one that
      # the quotes decode.
      rewrite("(string) @string") { |match| Raku.single_quoted(match[:string]) }
      rewrite("(interpolated_string) @string") { |match| Raku.double_quoted(match[:string]) }

      # `say $x if $y` is `if $y { say $x }`, and the same for unless and for.
      rewrite '(statement_modifier body: (_) @body modifier: "if" condition: (_) @condition)',
        '(if_statement "if" condition: @condition consequence: (block "{" @body "}"))'
      rewrite '(statement_modifier body: (_) @body modifier: "unless" condition: (_) @condition)',
        '(unless_statement "unless" condition: @condition consequence: (block "{" @body "}"))'
      rewrite '(statement_modifier body: (_) @body modifier: "for" condition: (_) @list)',
        '(for_statement "for" iterable: @list body: (block "{" @body "}"))'

      # A variable has the type of its sigil.
      rewrite("(variable) @variable") { |match| leaf(SIGILS.fetch(match[:variable].text[0], "scalar"), match[:variable].text) }

      # Names that the student defines.
      rewrite("(variable_declaration) @declaration") { |match| Raku.name_variables(match.node) ? match.node : nil }
      rewrite("(parameter) @parameter") { |match| Raku.name_variables(match.node) ? match.node : nil }
      rewrite "[(routine_declaration name: (identifier) @name) (package_declaration name: (identifier) @name)]" do |match|
        match[:name].type = "definition"
        match.node
      end
      rewrite "[(unit_declaration name: (identifier) @name) (constant_declaration name: (identifier) @name)]" do |match|
        match[:name].type = "definition"
        match.node
      end

      ### Rename and keep ###

      rename "[#{VARIABLES.map { |type| "(local_#{type}) @name" }.join(' ')}]"
      rename_member "(definition) @name"
      member "[(method_call method: (identifier) @name) (topic_method_call method: (identifier) @name)]"

      # Variables that Raku sets, and the names it calls itself.
      keep "$_", "@_", "%_", "$/", "$!", "self"
      library_names File.join(__dir__, "library_names", "raku.txt")

      DOUBLE_QUOTE_ESCAPES = { "\\n" => "\n", "\\t" => "\t", "\\\"" => "\"", "\\\\" => "\\", "\\$" => "$", "\\@" => "@",
                               "\\%" => "%", "\\&" => "&", "\\{" => "{" }.freeze

      class << self
        # 'it\'s', ‘it's’: the text between the quotes, with the escapes that
        # single quotes decode (\' and \\) decoded.
        def single_quoted(node)
          text = node.text
          return nil unless text.match?(/\A(?:'.*'|‘.*’)\z/m)

          inner = text[1...-1]
          inner = inner.gsub(/\\(['\\])/, '\1') if text.start_with?("'")
          return nil if text.start_with?("‘") && inner.include?("\\")

          literal(inner)
        end

        # "a\nb": the text, if it has no interpolation and every escape is one
        # that is decoded here. Any other escape (such as \x41) could mean
        # something that a single-quoted string spells differently, so such a
        # string keeps its structure.
        def double_quoted(node)
          pieces = node.children.map do |child|
            case child.type
            when "string_content" then child.text
            when "escape_sequence" then DOUBLE_QUOTE_ESCAPES[child.text]
            end
          end
          return nil if pieces.any?(&:nil?) || node.children.empty? && node.text.nil?

          literal(pieces.join)
        end

        # Gives the variables that a declaration or a parameter defines the
        # `local` type, and returns whether it changed anything. Public
        # attributes (`$.size`) stay, because their name is also the name of a
        # method that callers use, and so do named parameters (`:$size`).
        def name_variables(node)
          changed = false
          node.children.each do |child|
            next unless child.field == "name"

            if VARIABLES.include?(child.type) && !child.text.match?(/\A[$@%&]\./)
              child.type = "local_#{child.type}"
              changed = true
            elsif child.type == "sigilless_variable"
              child.type = "local_scalar"
              child.text = child.text.delete_prefix("\\")
              changed = true
            end
          end
          changed
        end
      end
    end
  end
end
