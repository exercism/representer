# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that Bash's parser reads the
# same way.
module Inspector::Languages::Bash::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Bash reads `function f { ... }`, `function f() { ... }`
    # and `f() { ... }` as the same function. Keep `then`, which ends the
    # condition of an `if`, and `until` and `select`, which share their node
    # types with `while` and `for`.
    # function f { :; }  ->  (function_definition f (compound_statement (command :)))
    # if a; then b; fi  ->  (if_statement (command a) then (command b))
    strip_tokens "if", "elif", "else", "fi", "for", "while", "do", "done", "case", "esac", "function"

    # Strip the `in` of a `case`, and keep the `in` of a `for`, because
    # `for x in; do` loops over nothing and `for x; do` loops over the
    # arguments.
    # case $x in a) ...  ->  (case_statement (simple_expansion x) (case_item a ...))
    strip_tokens "in", only_in: :case_statement

    # Strip the brackets, quotes and separators, because they are layout or
    # the node types already show them. Bash reads `$(date)` and `` `date` ``
    # as the same command substitution, and `$[1 + 2]` as `$((1 + 2))`.
    # f() ( echo hi )  ->  (function_definition f (subshell (command echo hi)))
    # arr=(a b)  ->  (variable_assignment arr (array a b))
    # `date`  ->  (command_substitution (command date))
    strip_tokens "(", ")", "{", "}", "${", "]", "]]", "((", "))", "$((", "$[", "$(", "`", "\"", ";", ";;", "<<<", ".."

    # Keep the `;` in a `for ((...))` header, because they show which of its
    # three parts are empty.
    # for ((; i < 3;))  ->  (c_style_for_statement ; (binary_expression i < 3) ;)
    keep_tokens ";", in: :c_style_for_statement

    # Strip these tokens only where the node type already shows them.
    # Elsewhere they are operators, or a `$` that is part of a word.
    # $x  ->  (simple_expansion x)
    # x=1  ->  (variable_assignment x 1)
    # a ? b : c  ->  (ternary_expression a b c)
    # ! true  ->  (negated_command (command true))
    # case $x in a|b) ...  ->  (case_item a b ...)
    strip_tokens "$", only_in: :simple_expansion
    strip_tokens "=", only_in: :variable_assignment
    strip_tokens "[", only_in: :subscript
    strip_tokens "?", ":", only_in: :ternary_expression
    strip_tokens "!", only_in: :negated_command
    strip_tokens "|", only_in: [:case_item, :last_case_item]

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (( (a + b) * c ))  ->  (arithmetic_command (binary_expression (binary_expression a + b) * c))
    unwrap :parenthesized_expression

    BUILTIN_VARIABLES = [
      "BASH", "BASHOPTS", "BASHPID", "BASH_ARGC", "BASH_ARGV", "BASH_COMMAND", "BASH_LINENO", "BASH_REMATCH",
      "BASH_SOURCE", "BASH_SUBSHELL", "BASH_VERSINFO", "BASH_VERSION", "COLUMNS", "DIRSTACK", "EPOCHREALTIME",
      "EPOCHSECONDS", "EUID", "FUNCNAME", "GLOBIGNORE", "GROUPS", "HOME", "HOSTNAME", "IFS", "LANG", "LC_ALL",
      "LC_COLLATE", "LC_CTYPE", "LC_MESSAGES", "LC_NUMERIC", "LINENO", "LINES", "MAPFILE", "OLDPWD", "OPTARG",
      "OPTERR", "OPTIND", "PATH", "PIPESTATUS", "PPID", "PWD", "RANDOM", "REPLY", "SECONDS", "SHELL", "SHELLOPTS",
      "SHLVL", "TERM", "TIMEFORMAT", "TMPDIR", "TZ", "UID", "USER"
    ].freeze

    # Each of these builtins fills the variables named by its arguments.
    # These are its options that take a value, such as `read -d ,`, so
    # the word after one of them isn't a variable.
    # read -r -d , «first» «second»
    # mapfile -t «lines»
    VARIABLE_READERS = {
      "read" => ["d", "i", "n", "N", "p", "t", "u"],
      "mapfile" => ["C", "c", "d", "n", "O", "s", "u"],
      "readarray" => ["C", "c", "d", "n", "O", "s", "u"]
    }.freeze

    ASSIGNMENT_OPERATORS = ["=", "+=", "-=", "*=", "/=", "%=", "**=", "<<=", ">>=", "&=", "^=", "|="].freeze
    UPDATE_OPERATORS = ["++", "--"].freeze

    # Bash reads a number in arithmetic with these prefixes. A number can
    # also give its base before a `#`, as in `2#101`.
    PREFIXES = { "0x" => 16, "0" => 8 }.freeze

    ARITHMETIC = ["arithmetic_expansion", "arithmetic_command", "c_style_for_statement"].freeze
    IDENTIFIER = /\A[A-Za-z_]\w*\z/

    # Inside double quotes, Bash reads these escapes, and keeps any other
    # backslash as it is written. A `\` at the end of a line joins the lines.
    QUOTED_ESCAPES = /\\(["\\$`\n])/

    ANSI_C_ESCAPES = {
      "n" => "\n",
      "t" => "\t",
      "r" => "\r",
      "\\" => "\\",
      "'" => "'",
      "\"" => "\""
    }.freeze

    def call
      tree.tap do
        drop_the_spaces_between_children!
        give_arithmetic_commands_a_type_of_their_own!
        drop_the_separator_after_a_for_header!
        write_strings_as_their_values!
        write_numbers_in_arithmetic_as_their_values!
        write_command_names_as_names!
        write_function_names_as_names!
        write_the_variables_in_arithmetic_as_names!
        write_the_variables_that_builtins_fill_as_names!
        give_builtin_variables_a_type_of_their_own!
        mark_the_variables_that_are_assigned_to!
      end
    end

    private
    # Drop the spaces around the text kept between the children of a node
    # (see common/spec.rb), because they are layout.
    # (( a + b ))  ->  (binary_expression a + b)
    # [[ $x =~ - ]]  ->  (binary_expression (simple_expansion x) =~ - (regex))
    def drop_the_spaces_between_children!
      each_node(tree) do |node, _|
        node.children.each { |child| child.text = child.text.strip if child.type == "fragment" }
        node.children.reject! { |child| child.type == "fragment" && child.text.empty? }
      end
    end

    # Give `(( ... ))` a type of its own, because the grammar gives it the
    # same type as a `{ ... }` group of commands.
    # (( x++ ))  ->  (arithmetic_command (postfix_expression x ++))
    def give_arithmetic_commands_a_type_of_their_own!
      find_all(tree, "(compound_statement \"((\") @command").each { |match| match.node.type = "arithmetic_command" }
    end

    # Drop the `;` between a `for ((...))` header and its body, because it
    # is layout.
    # for ((i = 0; i < 3; i++)); do  ->  for ((i = 0; i < 3; i++)) do
    def drop_the_separator_after_a_for_header!
      find_all(tree, "(c_style_for_statement) @for").each do |match|
        header_end = match.node.children.index { |child| child.type == "))" }
        kept = match.node.children.each_with_index.reject { |child, index| index > header_end && child.type == ";" }
        match.node.children = kept.map(&:first)
      end
    end

    ### Strings and numbers ###

    # Turn each quoted string into its value, and read its escapes. Keep a
    # double-quoted string that holds an expansion as a string of its
    # pieces, because Bash doesn't split the expansion into words.
    #
    # 'say "hi"'  ->  "say \"hi\""
    # "say \"hi\""  ->  "say \"hi\""
    # "hi $name"  ->  (string "hi " (simple_expansion name))
    # $'a\tb'  ->  the string a, a tab and b
    def write_strings_as_their_values!
      transform(tree, "[(string) (raw_string) (ansi_c_string)] @string") do |match|
        case match.node.type
        when "string" then string_node(string_pieces(match.node))
        when "raw_string" then literal(match.node.text[1...-1])
        else ansi_c_value(match.node.text[2...-1])&.then { |value| literal(value) }
        end
      end
    end

    # The pieces of a double-quoted string: its text, with the escapes read,
    # and its expansions. A `$` that starts nothing is text.
    def string_pieces(node)
      node.children.filter_map do |child|
        if child.type == "string_content" then child.text.gsub(QUOTED_ESCAPES) { |escape| escape == "\\\n" ? "" : escape[1] }
        elsif child.type == "$" then "$"
        elsif child.named? then child
        end
      end
    end

    # Build a string's value from its pieces: a literal if it is all text,
    # or a string of literals and expansions. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    # The value of a `$'...'` string, or nil if it holds an escape that this
    # stage doesn't read, so it can't make two different strings the same.
    def ansi_c_value(text)
      return nil unless text.scan(/\\(.)/m).flatten.all? { |escape| ANSI_C_ESCAPES.key?(escape) }

      text.gsub(/\\(.)/m) { |escape| ANSI_C_ESCAPES.fetch(escape[1]) }
    end

    # Write each number in arithmetic as its value. Outside arithmetic,
    # Bash reads a number as text, so `x=010` keeps its leading 0.
    #
    # (( x = 0x1F ))  ->  (( x = 31 ))
    # (( x = 010 ))  ->  (( x = 8 ))
    # (( x = 2#101 ))  ->  (( x = 5 ))
    def write_numbers_in_arithmetic_as_their_values!
      each_in_arithmetic do |node|
        value = node.type == "number" && number_value(node.text)
        node.text = value.to_s if value
      end
    end

    def number_value(text)
      base, digits = text.split("#", 2)
      return Inspector::Engine::Numbers.integer(text, separator: "", prefixes: PREFIXES) unless digits

      Integer(digits, base.to_i) if base.to_i.between?(2, 36)
    rescue ArgumentError
      nil
    end

    ### Names ###

    # Write the name of each command as a leaf, so that representation/spec.rb
    # can list it as a name. A call to a function the solution defines then
    # gets the function's placeholder.
    # main "$@"  ->  (command main (string (simple_expansion @)))
    def write_command_names_as_names!
      transform(tree, "(command_name (word) @word) @name") do |match|
        leaf(:command_name, match[:word].text) if match.node.children.one?
      end
    end

    # Give the name of each function a type of its own, so that it is a name.
    # f() { :; }  ->  (function_definition (function_name f) ...)
    def write_function_names_as_names!
      captured(tree, "(function_definition name: (word) @name)").each { |name| name.type = "function_name" }
    end

    # Write each word in arithmetic or in an array's index that is a name as a
    # variable name, because Bash reads it as the variable. The grammar reads
    # some of them as words.
    # for ((i = 0; i < 3; i++))  ->  the `i` in `i < 3` and `i++` is the variable i
    # ${letters[i]}  ->  the `i` is the variable i
    def write_the_variables_in_arithmetic_as_names!
      each_in_arithmetic(also: ["subscript"]) do |node|
        node.type = "variable_name" if node.type == "word" && node.text.match?(IDENTIFIER)
      end
    end

    # Write each variable that `read`, `mapfile`, `readarray`, `printf -v`
    # and `getopts` fill as a variable name, and give it the field `filled`,
    # so that representation/spec.rb can list it with the other names that are
    # assigned to.
    # read -r «line»
    # printf -v «padded» "%03d" "$n"
    # getopts "ab:" «option»
    def write_the_variables_that_builtins_fill_as_names!
      find_all(tree, "(command name: (command_name) @name) @command").each do |match|
        arguments = match.node.children.select { |child| child.field == "argument" }
        filled_arguments(match[:name].text, arguments).each do |word|
          next unless word.type == "word" && word.text.match?(IDENTIFIER)

          word.type = "variable_name"
          word.field = "filled"
        end
      end
    end

    def filled_arguments(command, arguments)
      case command
      when "printf" then arguments.each_cons(2).select { |option, _| option.text == "-v" }.map(&:last)
      when "getopts" then arguments[1, 1]
      when *VARIABLE_READERS.keys then read_arguments(arguments, VARIABLE_READERS[command])
      else []
      end
    end

    # The arguments of `read` or `mapfile` that aren't options or the values
    # of options.
    # read -r -d , «first» «second»
    def read_arguments(arguments, options_with_values)
      takes_value = false
      arguments.reject do |argument|
        option = argument.type == "word" && argument.text.start_with?("-")
        skip = option || takes_value
        takes_value = option && options_with_values.include?(argument.text[-1])
        skip
      end
    end

    # Give Bash's own variables a type of their own, so that they keep their
    # names. Bash defines them, so assigning to one doesn't define a name.
    # IFS=, read -r a b  ->  (command (variable_assignment (builtin_variable IFS) ,) read a b)
    def give_builtin_variables_a_type_of_their_own!
      each_node(tree) do |node, _|
        node.type = "builtin_variable" if node.type == "variable_name" && BUILTIN_VARIABLES.include?(node.text)
      end
    end

    # Give each variable that is assigned to in arithmetic, or as an item of
    # an array, the field `assigned`, so that representation/spec.rb can list
    # it with the other names that are assigned to.
    # (( «count» += 1 ))
    # (( «i»++ ))
    # «seen»[$word]=1
    def mark_the_variables_that_are_assigned_to!
      each_node(tree) do |node, parent|
        variable = assigned_variable(node, parent)
        variable.field = "assigned" if variable&.type == "variable_name"
      end
    end

    def assigned_variable(node, parent)
      case node.type
      when "binary_expression" then node[:left] if ASSIGNMENT_OPERATORS.include?(node[:operator]&.type)
      when "postfix_expression", "unary_expression"
        node.named_children.first if UPDATE_OPERATORS.include?(node[:operator]&.type)
      when "subscript" then node[:name] if parent&.type == "variable_assignment" && node.field == "name"
      end
    end

    # Calls the block with each named leaf in arithmetic, and in the node
    # types given in also.
    def each_in_arithmetic(also: [])
      each_node(tree) do |node, _|
        arithmetic_parts(node, ARITHMETIC + also).each do |part|
          each_node(part) { |inner, _| yield inner if inner.leaf? && inner.named? }
        end
      end
    end

    # The children of a node that Bash reads as arithmetic. A `for ((...))`
    # loop's body isn't arithmetic, and an expansion's offset and length are.
    # ${word:«i»:«1»}
    def arithmetic_parts(node, types)
      return node.children.reject { |child| child.field == "body" } if types.include?(node.type)
      return [] unless node.type == "expansion"

      after_colon = false
      node.children.select { |child| (after_colon ||= child.type == ":") && child.named? }
    end
  end
end
