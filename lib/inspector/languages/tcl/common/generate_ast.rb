# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the words that Tcl's own parser reads, where each word that has no
# substitutions is its string value, and marks the names that each command
# defines.
module Inspector::Languages::Tcl::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Tcl reads `then` and `else` as optional words.
    # if {$a} then {b} else {c}  ->  if {$a} {b} {c}
    strip_tokens "proc", "set", "foreach", "while", "for", "expr", "catch", "regexp", "regsub", "variable", "global",
                 "namespace", "try", "finally", "trap", "if", "elseif", "else", "then"
    strip_tokens "on", only_in: :on

    # Strip the brackets and separators, because they are layout. A newline
    # and a `;` both end a command.
    # set a 1; set b 2  ->  (set a 1) (set b 2)
    strip_tokens "\n", ";", "[", "]", "(", ")", "{", "}", "{*}", ","
    strip_tokens "$", only_in: :variable_substitution
    strip_tokens "?", ":", only_in: :ternary_expr

    # Keep the braces around an expression, because Tcl substitutes into an
    # unbraced expression before `expr` reads it.
    # expr {$a + 1}  !=  expr $a + 1
    keep_tokens "{", "}", in: :expr

    # Write each number in an expression as its value. Tcl reads a number
    # with a leading zero as a decimal.
    # 0x1F  ->  31
    # 1e3  ->  1000.0
    # .5  ->  0.5
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "0x" => 16, "0o" => 8, "0b" => 2 },
                separators: []

    # Tcl also reads a backslash before any character that isn't a letter or
    # a digit as that character, and a backslash and a line break, with the
    # spaces after it, as one space.
    ESCAPES = { "\\n" => "\n", "\\t" => "\t", "\\r" => "\r" }.freeze
    KEPT_ESCAPES = /\A\\[[:alnum:]\n]\z/

    # Tcl reads a word with no special characters the same, with or without
    # quotes or braces.
    BARE_WORD = /\A[^!$\s\\\[\]{}();"]+\z/

    WORD_PARTS = ["simple_word", "quoted_word", "braced_word", "braced_word_simple", "variable_substitution",
                  "command_substitution", "escaped_character", "array_index", "unpack"].freeze

    WORD_HOLDERS = ["word_list", "command", "array_index", "set", "procedure", "foreach", "for", "while", "if", "elseif",
                    "else", "try", "on", "trap", "finally", "catch", "regexp", "regsub", "variable", "global"].freeze

    EXPRESSIONS = ["expr", "binop_expr", "unary_expr", "ternary_expr", "function_arguments"].freeze

    def call
      tree.tap do
        join_the_parts_of_each_word!
        join_namespaces_to_their_variables!
        write_booleans_as_leaves!
        write_braced_variable_names_as_names!
        write_strings_as_their_values!
        write_empty_scripts_as_empty_strings!
        write_expansions_around_their_words!
        write_one_name_argument_lists_as_lists!
        mark_the_names_each_command_defines!
      end
    end

    private
    ### Words ###

    # Join the parts of a word that sit next to each other with no space,
    # because Tcl reads them as one word. The grammar gives each part as a
    # child of its own, so this stage reads the spaces between them.
    # puts a$b  ->  (command puts (word_list (word a $b)))
    # puts a $b  ->  (command puts (word_list a $b))
    def join_the_parts_of_each_word!
      each_node(tree) do |node, _|
        next unless WORD_HOLDERS.include?(node.type)

        node.children = words(node.children)
      end
    end

    def words(children)
      result = []
      word = []
      children.each do |child|
        if WORD_PARTS.include?(child.type)
          word << child
          next
        end

        result << join(word) unless word.empty?
        word = []
        result << child unless child.type == "fragment" && space?(child.text)
      end
      result << join(word) unless word.empty?
      result
    end

    def join(parts) = parts.one? ? parts.first : build(:word, *parts)

    def space?(text) = text.match?(/\A(\s|\\\r?\n)*\z/)

    # Join the namespace after a variable to its name, because Tcl reads
    # `$a::b` as the variable `a::b`, and the grammar ends the variable at
    # `a`. A variable in braces, as in `${a}::b`, ends at its brace.
    # puts $a::b  ->  (command puts (word_list $a::b))
    def join_namespaces_to_their_variables!
      each_node(tree) do |node, _|
        next unless node.type == "word"

        node.children.each_cons(2) do |variable, after|
          name = variable.children.last if variable.type == "variable_substitution"
          namespace = after.text[/\A(::\w+)+/] if after.type == "simple_word"
          next unless name&.type == "id" && namespace

          name.text += namespace
          after.text = after.text.delete_prefix(namespace)
        end
        node.children = node.children.reject { |child| child.type == "simple_word" && child.text.empty? }
      end
    end

    # Write each `true` and `false` in an expression as a leaf, because the
    # grammar leaves them out of the tree.
    # expr {$a && true}  ->  (expr { (binop_expr $a && true) })
    def write_booleans_as_leaves!
      each_node(tree) do |node, _|
        next unless EXPRESSIONS.include?(node.type)

        node.children = node.children.filter_map do |child|
          next child unless child.type == "fragment"

          leaf(:boolean, child.text.strip) unless space?(child.text)
        end
      end
    end

    # Write `${x}` as `$x`, because Tcl reads them as the same variable.
    def write_braced_variable_names_as_names!
      each_node(tree) do |node, _|
        next unless node.type == "variable_substitution"

        node.children = node.children.map { |child| child.type == "fragment" ? leaf(:id, child.text) : child }
      end
    end

    # Write each word as its value, because Tcl reads a word the same
    # whether it is bare, in quotes or in braces, if nothing is substituted
    # into it. A word with no special characters becomes a name, as bare
    # words are, and every other value becomes a string. A word with
    # substitutions becomes a `word` of its parts.
    #
    # "abc"  ->  abc
    # {a b}  ->  "a b"
    # "a\$b"  ->  "a$b"
    # "a $b"  ->  (word "a " $b)
    # "$b"  ->  $b
    def write_strings_as_their_values!
      transform(tree, "(braced_word_simple) @word") { |match| value([braced_text(match.node)]) }
      transform(tree, "[(quoted_word) (word)] @word") do |match|
        value(match.node.children.filter_map { |part| part_value(part) })
      end
      transform(tree, "(escaped_character) @word") { |match| value([escape(match.node)]) }
    end

    # Tcl reads a backslash and a line break in braces as one space, and
    # keeps every other character as it is.
    def braced_text(node)
      inner = node.children.filter_map do |child|
        case child.type
        when "fragment" then child.text
        when "braced_word_simple" then "{#{braced_text(child)}}"
        when "{*}" then "*"
        end
      end
      inner.join.gsub(/\\\r?\n[ \t]*/, " ")
    end

    def part_value(part)
      case part.type
      when "\"" then nil
      when "fragment" then part.text.gsub(/\\\r?\n[ \t]*/, " ")
      when "$" then "$"
      when "simple_word" then part.text
      when "escaped_character" then escape(part)
      else part
      end
    end

    # An escape that this stage doesn't read stays inside an `escape` node,
    # so it can never get the same value as a string.
    # "\x41"  ->  (escape "\\x41")
    def escape(part)
      return ESCAPES[part.text] if ESCAPES.key?(part.text)

      part.text.match?(KEPT_ESCAPES) ? build(:escape, part) : part.text[1]
    end

    def value(parts)
      runs = parts.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      runs = runs.map { |run| run.first.is_a?(String) ? run.join : run.first }
      return literal("") if runs.empty?
      return string(runs.first) if runs.one? && runs.first.is_a?(String)
      return runs.first if runs.one?

      build(:word, *runs.map { |run| run.is_a?(String) ? literal(run) : run })
    end

    def string(text) = text.match?(BARE_WORD) ? leaf(:simple_word, text) : literal(text)

    # Write an empty script in braces as an empty string, because Tcl reads
    # `{}` and `""` as the same word.
    # return {}  ->  return ""
    def write_empty_scripts_as_empty_strings!
      transform(tree, "(braced_word) @word") { |match| literal("") if match.node.named_children.empty? }
    end

    # Put each expanded word inside its `{*}`.
    # list {*}$a  ->  (list (unpack $a))
    def write_expansions_around_their_words!
      transform(tree, "(word (unpack) _*) @word") do |match|
        build(:unpack, *match.node.children.drop(1))
      end
    end

    # Write a list of one name without braces as a list in braces, because
    # Tcl reads `proc f a {}` and `proc f {a} {}` as the same.
    # foreach x $list {}  ->  foreach {x} $list {}
    def write_one_name_argument_lists_as_lists!
      each_node(tree) do |node, _|
        next unless node.type == "arguments" && node.children.map(&:type) == ["simple_word"]

        node.children = [build(:argument, { name: node.children.first })]
      end
    end

    ### Names ###

    # Wrap each name that a command defines in a `definition` node, so that
    # representation/spec.rb can list them in names_are_defined_by. Tcl
    # passes variables by name, so a command such as `lappend` or `incr`
    # creates the variable it names. A variable called `args` keeps its
    # name, because as a parameter it takes the rest of the arguments.
    #
    # set total 0  ->  (set (definition total) 0)
    # proc area {w h} {}  ->  (procedure (definition area) (arguments (argument (definition w)) ...) ...)
    # lassign $pair a b  ->  (command lassign (word_list $pair (definition a) (definition b)))
    def mark_the_names_each_command_defines!
      each_node(tree) do |node, _|
        case node.type
        when "set" then mark!(node, node.named_children.first)
        when "procedure" then mark!(node, node[:name])
        when "argument" then mark!(node, node[:name])
        when "variable" then node.named_children.each_slice(2) { |name, _| mark!(node, name) }
        when "catch" then node.named_children.drop(1).each { |name| mark!(node, name) }
        when "regexp" then match_variables(node.named_children, 2).each { |name| mark!(node, name) }
        when "regsub" then match_variables(node.named_children, 3).each { |name| mark!(node, name) }
        when "namespace" then mark_namespace!(node.named_children.first)
        when "command" then mark_command!(node)
        end
      end
    end

    # A `regexp` or `regsub` takes switches such as `-nocase`, up to `--`,
    # and `-start` takes a value. The variables come after its other
    # arguments.
    def match_variables(words, skip)
      index = 0
      while words[index]&.type == "simple_word" && words[index].text.start_with?("-")
        index += 1 if words[index].text == "-start"
        index += 1
        break if words[index - 1].text == "--"
      end
      words.drop(index + skip)
    end

    # namespace eval counter {...} defines counter.
    def mark_namespace!(list)
      words = list&.named_children || []
      mark!(list, words[1]) if words[0]&.text == "eval"
    end

    def mark_command!(command)
      words = [command[:name], *command[:arguments]&.named_children]
      parent = command[:arguments]
      case words.map { |word| word&.type == "simple_word" ? word.text : nil }
      in ["lassign", _, *] then words.drop(2).each { |name| mark!(parent, name) }
      in ["incr" | "append" | "lappend" | "array" | "dict" | "gets", *] then mark_variable_command!(parent, words)
      in ["scan", _, _, *] then words.drop(3).each { |name| mark!(parent, name) }
      in ["upvar", *] then mark_upvar!(parent, words.drop(1))
      in ["lmap", *] then words[1...-1].each_slice(2) { |names, _| mark_list!(parent, names) }
      in ["my", "variable", *] then words.drop(2).each { |name| mark!(parent, name) }
      in ["oo::class", "create", _, *] then mark!(parent, words[2])
      in ["method", _, _, *]
        mark!(parent, words[1])
        mark_parameters!(parent, words[2])
      in ["constructor", _, *] then mark_parameters!(parent, words[1])
      else nil
      end
    end

    # incr count  ->  defines count
    # array set counts {}  ->  defines counts
    # dict incr counts $word  ->  defines counts
    # dict for {key value} $counts {...}  ->  defines key and value
    # gets stdin line  ->  defines line
    def mark_variable_command!(parent, words)
      case words.map { |word| word&.type == "simple_word" ? word.text : nil }
      in ["incr" | "append" | "lappend", _, *] then mark!(parent, words[1])
      in ["array", "set", _, *] then mark!(parent, words[2])
      in ["dict", "for" | "map", _, *] then mark_list!(parent, words[2])
      in ["dict", "set" | "unset" | "lappend" | "append" | "incr" | "update" | "with", _, *] then mark!(parent, words[2])
      in ["gets", _, _, *] then mark!(parent, words[2])
      else nil
      end
    end

    # Tcl reads an odd number of arguments to `upvar` as a level, followed by
    # pairs of a caller's variable and the local name for it.
    # upvar 1 $name total  ->  defines total
    def mark_upvar!(parent, words)
      words = words.drop(1) if words.size.odd?
      words.each_slice(2) { |_, name| mark!(parent, name) }
    end

    # A list of names in braces is a script to the grammar, so its names are
    # the words of its commands.
    # {key value}  ->  defines key and value
    def mark_list!(parent, list)
      return mark!(parent, list) unless list&.type == "braced_word"

      list.named_children.each do |command|
        mark!(command, command[:name])
        command[:arguments]&.named_children&.each { |name| mark!(command[:arguments], name) }
      end
    end

    # A parameter with a default is a list in braces of its name and value.
    # {a {b 1}}  ->  defines a and b
    def mark_parameters!(parent, list)
      return mark!(parent, list) unless list&.type == "braced_word"

      list.named_children.each do |command|
        [command[:name], *command[:arguments]&.named_children].each do |parameter|
          holder = parameter.equal?(command[:name]) ? command : command[:arguments]
          next mark!(holder, parameter) unless parameter.type == "braced_word"

          inner = parameter.named_children.first
          mark!(inner, inner[:name]) if inner&.type == "command"
        end
      end
    end

    def mark!(parent, node)
      return unless parent && ["simple_word", "id"].include?(node&.type) && node.text != "args"

      parent.replace_child(node, build(:definition, node))
    end
  end
end
