# What this class does to a Raku solution's code to make its representation:
#
# - Drops comments and Pod.
# - Drops `use`, `need`, `require` and `import` of a module, and keeps
#   pragmas such as `use v6` and `use lib`.
# - Drops `;`, brackets that only group, and expression statement wrappers.
# - Writes numbers as their values (`1_000` is `1000`, `0x1F` is `31`, the
#   Rat `1.50` is `1.5`), and keeps a Num's text.
# - Writes a string as its value however it is quoted, and removes a
#   heredoc's indentation.
# - Writes `say $x if $y` as an `if` block, and the same for `unless` and
#   `for`.
# - Gives each variable the type of its sigil.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests and the members of the exercise's stub.
# - Also keeps `$_`, `@_`, `%_`, `$/`, `$!` and `self`.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # The old raku-representer printed Rakudo's `.AST.raku` and replaced every
    # name in it with a placeholder. It has two golden tests (whitespace and
    # comments), both of which give the same output. This class reads the code
    # with tree-sitter, so it needs no Rakudo, and renames only the names that
    # the student defines.
    class Raku < Language
      tracks "raku"
      version 8
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

      drop "[(comment) (pod)]"

      # `use`, `need`, `require` and `import` of a module only make its names
      # available. A pragma (`use v6`, `use lib`, `use MONKEY-SEE-NO-EVAL`)
      # changes how the code runs, so it stays. Modules start with a capital
      # letter, and pragmas don't (apart from the MONKEY ones).
      drop "(use_statement module: (identifier /\\A[A-Z]/) @module)", where: ->(match) { !match[:module].text.start_with?("MONKEY") }
      drop_tokens ";",
        "use"

      ### Rewrite ###

      # (a + b) is a + b, and an expression statement is its expression: the
      # tree's shape already shows both.
      unwrap :parenthesized_expression, :expression_statement

      # Numbers are their values: `1_000` is `1000`, `0x1F` is `31`, and the
      # Rat `1.50` is `1.5`. A Num such as `1e3` keeps its text.
      numbers(:integer) { |text| Engine::Numbers.integer(text)&.to_s }
      numbers :decimal do |text|
        value = !text.match?(/[eE]/) && Engine::Numbers.decimal(text)
        value && Engine::Numbers.write_decimal(value)
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

      # Raku removes a heredoc's indentation, up to the indentation of its
      # closing line, so a heredoc indented differently is the same text.
      rewrite "(heredoc_body) @body" do |match|
        *lines, closing = match.node.text.split("\n", -1)
        indentation = closing.to_s[/\A[ \t]+/]
        next nil if lines.empty? || indentation.nil?

        body = lines.map { |line| line.delete_prefix(indentation) }
        leaf(:heredoc_body, [*body, closing.delete_prefix(indentation)].join("\n"))
      end

      ### Rename and keep ###

      rename "[#{VARIABLES.map { |type| "(local_#{type}) @name" }.join(' ')}]"
      rename_member "(definition) @name"
      member "[(method_call method: (identifier) @name) (topic_method_call method: (identifier) @name)]"

      # Variables that Raku sets, and the names it calls itself.
      keep "$_", "@_", "%_", "$/", "$!", "self"
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
