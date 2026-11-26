module Representer
  module Languages
    # Every step of exercism/go-representer is a rule here. Each rule's
    # comment says which step it replaces.
    class Go < Language
      tracks "go"
      version 4
      grammar "go"
      extensions ".go"
      merge_files "solution.go"

      names :identifier, :field_identifier, :type_identifier, :label_name

      # For each built-in type that `var x T` can be rewritten for: the type
      # of literal that has T as its default type (so `x := 1` is an int),
      # and the zero value written as a literal, or nil if T has no literal
      # zero value. Every other type name that is listed gets the zero value
      # T(0). A built-in type missing from this table (error, any, and every
      # slice, map, pointer, array, channel, function and struct type) keeps
      # its `var` declaration, because `x := ...` can't say what it is. So
      # does a type the student defined, because only the student's code
      # knows its zero value.
      BUILTIN_TYPES = {
        "string" => { literals: %w[interpreted_string_literal raw_string_literal literal], zero: ->(go) { go.literal("") } },
        "bool" => { literals: %w[true false], zero: ->(go) { go.leaf("false", "false") } },
        "int" => { literals: %w[int_literal], zero: ->(go) { go.leaf(:int_literal, "0") } },
        "float64" => { literals: %w[float_literal], zero: ->(go) { go.leaf(:float_literal, "0.0") } },
        "complex128" => { literals: %w[imaginary_literal], zero: ->(go) { go.leaf(:imaginary_literal, "0i") } },
        "rune" => { literals: %w[rune_literal], zero: nil },
        "int8" => { literals: [], zero: nil }, "int16" => { literals: [], zero: nil },
        "int32" => { literals: [], zero: nil }, "int64" => { literals: [], zero: nil },
        "uint" => { literals: [], zero: nil }, "uint8" => { literals: [], zero: nil },
        "uint16" => { literals: [], zero: nil }, "uint32" => { literals: [], zero: nil },
        "uint64" => { literals: [], zero: nil }, "uintptr" => { literals: [], zero: nil },
        "byte" => { literals: [], zero: nil }, "float32" => { literals: [], zero: nil },
        "complex64" => { literals: [], zero: nil }
      }.freeze

      # Standard-library types that a solution commonly declares with
      # `var x T`, and the kind of zero value that each has: :composite for
      # `T{}` and :number for `T(0)`. Every other qualified type keeps its
      # `var` declaration.
      STANDARD_TYPES = {
        "strings.Builder" => :composite, "strings.Reader" => :composite, "bytes.Buffer" => :composite,
        "bytes.Reader" => :composite, "sync.Mutex" => :composite, "sync.RWMutex" => :composite,
        "sync.WaitGroup" => :composite, "sync.Once" => :composite, "sync.Map" => :composite,
        "sync.Pool" => :composite, "sync.Cond" => :composite, "time.Time" => :composite,
        "list.List" => :composite, "big.Int" => :composite, "big.Float" => :composite, "big.Rat" => :composite,
        "atomic.Int32" => :composite, "atomic.Int64" => :composite, "atomic.Uint32" => :composite,
        "atomic.Uint64" => :composite, "atomic.Bool" => :composite, "atomic.Value" => :composite,
        "regexp.Regexp" => :composite, "bufio.Scanner" => :composite, "tabwriter.Writer" => :composite,
        "time.Duration" => :number, "time.Month" => :number, "time.Weekday" => :number,
        "os.FileMode" => :number, "reflect.Kind" => :number, "token.Token" => :number
      }.freeze

      # Top-level declarations are written in this order.
      DECLARATION_ORDER = {
        "import_declaration" => 0, "type_declaration" => 1, "const_declaration" => 2,
        "var_declaration" => 3, "function_declaration" => 4, "method_declaration" => 4
      }.freeze

      ### Drop ###

      comments "(comment)"

      # The node types already say what these tokens say. A ";" is only
      # meaningful between the parts of a for loop, so a rule below removes
      # the others. The quotes go because a string's value doesn't depend on
      # them.
      drop_tokens "(", ")", "{", "}", "[", "]", ",", ".", "\"", "`", "import", "package", "func", "type", "struct",
        "interface", "map", "var", "const", "if", "else", "for", "switch", "select", "case", "default", "return"

      ### Snippet ###

      # The snippet skips the package clause and imports at the top of the file.
      snippet_header "(package_clause)", "(import_declaration)"

      ### Rewrite ###

      # A semicolon between statements or fields is the same as a new line.
      rewrite '(_ ";")', where: ->(match) { match.node.type != "for_clause" } do |match|
        match.node.children.reject! { |child| !child.named? && child.type == ";" }
        match.node
      end

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression, :parenthesized_type

      # SortDeclarations (and merging import groups): `import "a"` and
      # `import ("a")` are the same, grouped declarations are separate
      # declarations, and the file's declarations are in a fixed order. The
      # old representer sorted by kind and then by source length, largest
      # first. This sorts by node count, because source length depends on
      # formatting.
      rewrite "(source_file) @file" do |match|
        Go.expand_defined_vars(match.node)
        organised = Go.organise(match.node.children)
        organised.map(&:inspect) == match.node.children.map(&:inspect) ? nil : build(:source_file, *organised)
      end

      # NormalizeDeclarations: `var a int` is `a := 0` inside a function. The
      # rule above also does this for types that the solution defines, once it
      # has the whole file.
      rewrite "(statement_list (var_declaration) @declaration)" do |match|
        statements = match.node.children.flat_map do |child|
          child.type == "var_declaration" ? (Go.expand_var(child) || [child]) : [child]
        end
        statements.map(&:inspect) == match.node.children.map(&:inspect) ? nil : build(:statement_list, *statements)
      end

      # A string is its value: "a" and `a` are the same.
      rewrite "[(interpreted_string_literal) @string (raw_string_literal) @string]" do |match|
        parts = match.node.children.select(&:named?)
        next nil unless parts.all? { |part| STRING_PARTS.include?(part.type) }

        value = parts.map { |part| part.type == "escape_sequence" ? Go.decode(part.text) : part.text }.join
        literal(match.node.type == "raw_string_literal" ? value.delete("\r") : value)
      end

      ### Rename and keep ###

      # NormalizeNaming. Every identifier the student defines is renamed.
      # A declaration can define several names (`a, b int`), so these
      # patterns take every identifier child, which are all names.
      rename "(parameter_declaration (identifier)* @name)"
      rename "(variadic_parameter_declaration name: (identifier) @name)"
      rename "(type_parameter_declaration (identifier)* @name)"
      rename "(short_var_declaration left: (expression_list (identifier)* @name))"
      rename "(range_clause left: (expression_list (identifier)* @name))"
      rename "(receive_statement left: (expression_list (identifier)* @name))"
      rename "(type_switch_statement alias: (expression_list (identifier)* @name))"
      rename "(var_spec (identifier)* @name)"
      rename "(const_spec (identifier)* @name)"
      rename "[(function_declaration name: (identifier) @name) (labeled_statement label: (label_name) @name)]"
      rename "[(type_spec name: (type_identifier) @name) (type_alias name: (type_identifier) @name)]"

      # Methods and struct fields can be reached from other code, so they are
      # renamed after a dot too.
      rename_member "[(method_declaration name: (field_identifier) @name) (method_elem name: (field_identifier) @name)]"
      rename_member "(field_declaration (field_identifier)* @name)"

      # A name after a dot refers to some value's method or field. This also
      # keeps the names of other packages' functions (fmt.Println).
      member "(selector_expression field: (field_identifier) @name)"

      keep "_", "main", "init"

      # Methods that the standard library calls.
      keep "String", "Error", "Len", "Less", "Swap", "Push", "Pop", "Read", "Write", "Close", "Unwrap", "Is", "As",
        "MarshalJSON", "UnmarshalJSON", "MarshalText", "UnmarshalText", "ServeHTTP", "Format", "Scan", "Seek",
        "ReadFrom", "WriteTo", "ReadByte", "WriteByte", "ReadRune", "WriteRune", "WriteString", "Next"

      library_names File.join(__dir__, "library_names", "go.txt")

      STRING_PARTS = %w[interpreted_string_literal_content raw_string_literal_content escape_sequence].freeze

      ESCAPES = {
        "a" => "\a", "b" => "\b", "f" => "\f", "n" => "\n", "r" => "\r", "t" => "\t", "v" => "\v",
        "\\" => "\\", "\"" => "\""
      }.freeze

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value. A byte escape (\x or
      # an octal one) above 127 isn't a character on its own, so it stays as
      # written.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au([0-9a-fA-F]{4})\z/, /\AU([0-9a-fA-F]{8})\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        when /\Ax([0-9a-fA-F]{2})\z/
          Regexp.last_match(1).to_i(16).then { |value| value < 0x80 ? value.chr : escape }
        when /\A([0-7]{3})\z/
          Regexp.last_match(1).to_i(8).then { |value| value < 0x80 ? value.chr : escape }
        else ESCAPES.fetch(code, escape)
        end
      end

      ### Helpers for the rules above ###

      # The package clause, then one import declaration with its imports in
      # order, then every other declaration by kind and then by size, largest
      # first.
      def self.organise(children)
        head, rest = children.partition { |child| child.type == "package_clause" }
        head = head.uniq(&:inspect)
        imports, others = rest.partition { |child| child.type == "import_declaration" }
        others = others.flat_map { |declaration| split(declaration) }

        specs = imports.flat_map do |declaration|
          declaration.children.flat_map do |child|
            child.type == "import_spec_list" ? child.children : [child]
          end
        end
        specs = specs.select { |child| child.type == "import_spec" }.uniq(&:inspect).sort_by { |spec| key(spec) }
        import_declaration = specs.empty? ? [] : [Engine::Node.new("import_declaration",
          [Engine::Node.new("import_spec_list", specs)])]

        others = others.each_with_index.sort_by do |declaration, index|
          [DECLARATION_ORDER.fetch(declaration.type, 4), -size(declaration), key(declaration), index]
        end.map(&:first)
        head + import_declaration + others
      end

      # `type ( A int; B int )` is two type declarations, and so is a grouped
      # var. A const group stays whole, because `iota` and a repeated value
      # depend on the group.
      def self.split(declaration)
        return [declaration] unless %w[type_declaration var_declaration].include?(declaration.type)

        specs = declaration.children.flat_map { |child| child.type == "var_spec_list" ? child.children : [child] }
        specs = specs.select { |child| child.type.end_with?("_spec") || child.type == "type_alias" }
        return [declaration] if specs.size < 2 && declaration.children.none? { |child| child.type == "var_spec_list" }

        specs.map { |spec| Engine::Node.new(declaration.type, [spec]) }
      end

      def self.size(node)
        count = 0
        node.each_descendant { count += 1 }
        count
      end

      # The node's text with every name left out, to put equal-sized
      # declarations in an order that doesn't depend on what they are called.
      def self.key(node)
        parts = []
        node.each_descendant do |descendant|
          next unless descendant.leaf?

          parts << (names.key?(descendant.type) ? "" : descendant.text.to_s)
        end
        parts.join(" ")
      end

      def self.names = @names ||= Go.names

      # Rewrites the `var` declarations in the file's functions that name a
      # type the file defines. A type with type parameters is left alone.
      def self.expand_defined_vars(file)
        types = defined_types(file)
        file.each_descendant do |node|
          next unless node.type == "statement_list" && node.children.any? { |child| child.type == "var_declaration" }

          node.children = node.children.flat_map do |child|
            child.type == "var_declaration" ? (expand_var(child, types) || [child]) : [child]
          end
        end
      end

      # The type that each top-level type declaration defines, by name.
      def self.defined_types(file)
        file.children.select { |child| child.type == "type_declaration" }.flat_map(&:children).
          select { |spec| spec.type == "type_spec" && spec["type_parameters"].nil? && spec["name"] && spec["type"] }.
          to_h { |spec| [spec["name"].text, spec["type"]] }
      end

      # The statements that replace a var declaration, or nil if the
      # declaration has anything that this can't rewrite (see BUILTIN_TYPES).
      def self.expand_var(declaration, types = {})
        specs = declaration.children.flat_map { |child| child.type == "var_spec_list" ? child.children : [child] }
        specs = specs.select { |child| child.type == "var_spec" }
        statements = specs.map { |spec| expand_spec(spec, types) }
        statements.all? ? statements.flatten : nil
      end

      def self.expand_spec(spec, types)
        names = spec.children.select { |child| child.field == "name" && child.type == "identifier" }
        type = spec["type"]
        values = spec["value"]&.named_children || []
        return nil if names.empty? || names.any? { |name| name.text == "_" }
        return nil unless values.empty? || values.size == names.size

        # `var a, b = 1, a` reads the outer a, but `a := 1; b := a` wouldn't.
        declared = names.map(&:text)
        return nil if names.size > 1 && values.any? { |value| mentions?(value, declared) }

        names.each_with_index.map do |name, index|
          value = value_for(type, values[index], types)
          return nil unless value

          Engine::Node.new("short_var_declaration", [
                             leaf_field(Engine::Node.new("expression_list", [name]), "left"),
                             Engine::Node.token(":="),
                             leaf_field(Engine::Node.new("expression_list", [value]), "right")
                           ])
        end
      end

      def self.leaf_field(node, field) = node.tap { node.field = field }

      def self.mentions?(node, names)
        node.each_descendant { |descendant| return true if descendant.leaf? && names.include?(descendant.text) }
        false
      end

      # The value that `var x T = value` gives x, written without the type.
      # Returns nil if that can't be done.
      def self.value_for(type, value, types = {})
        return value if type.nil?
        return standard_value(type, value) if type.type == "qualified_type"
        return nil unless type.type == "type_identifier"

        info = BUILTIN_TYPES[type.text]
        if value.nil?
          return defined_zero(type, types) unless info

          return info[:zero] ? info[:zero].(self) : conversion(type, leaf(:int_literal, "0"))
        end
        return value if info && info[:literals].include?(value.type)
        return value if value.type == "call_expression" && value["function"]&.text == type.text
        return value if value.type == "composite_literal" && value["type"]&.text == type.text

        conversion(type, value)
      end

      # `var x strings.Builder` is `x := strings.Builder{}`.
      def self.standard_value(type, value)
        kind = STANDARD_TYPES[qualified_name(type)]
        return nil unless kind

        zero = parse_expression("#{qualified_name(type)}#{kind == :composite ? '{}' : '(0)'}")
        return zero if value.nil?

        value.type == zero.type && value["type"]&.then { |t| qualified_name(t) } == qualified_name(type) ? value : nil
      end

      def self.qualified_name(type) = type.children.select(&:leaf?).map(&:text).join(".")

      # The zero value of a type that the file defines, written as a
      # composite literal (`T{}`) or a conversion (`T(0)`). Returns nil if
      # the type isn't defined in the file or has no zero value that is
      # known.
      def self.defined_zero(type, types)
        return nil unless types.key?(type.text)

        kind = underlying_zero(types[type.text], types, [type.text])
        case kind
        when nil then nil
        when :composite then parse_expression("#{type.text}{}")
        else conversion(type, kind)
        end
      end

      # What the zero value of a type's definition looks like: :composite,
      # or the node to convert (0, "", false or nil). Returns nil if it isn't
      # known.
      def self.underlying_zero(type, types, seen)
        case type.type
        when "struct_type", "array_type" then :composite
        when "slice_type", "map_type", "pointer_type", "function_type", "channel_type", "interface_type"
          leaf("nil", "nil")
        when "qualified_type"
          STANDARD_TYPES[qualified_name(type)]&.then { |kind| kind == :composite ? :composite : leaf(:int_literal, "0") }
        when "type_identifier"
          name = type.text
          if (info = BUILTIN_TYPES[name])
            info[:zero] ? info[:zero].(self) : leaf(:int_literal, "0")
          elsif %w[error any].include?(name)
            leaf("nil", "nil")
          elsif types.key?(name) && !seen.include?(name)
            underlying_zero(types[name], types, seen + [name])
          end
        end
      end

      # A node for a piece of Go code, made by parsing it.
      def self.parse_expression(code)
        tree = Engine::Grammar[grammar].parse("package p\nvar _ = #{code}\n", skip_tokens: dropped_tokens,
          text_types: text_node_types, gap_types: gap_types)
        found = nil
        tree.each_descendant { |node| found ||= node if %w[composite_literal call_expression].include?(node.type) }
        found
      end

      def self.conversion(type, value)
        function = Engine::Node.leaf("identifier", type.text)
        function.field = "function"
        arguments = Engine::Node.new("argument_list", [value])
        arguments.field = "arguments"
        Engine::Node.new("call_expression", [function, arguments])
      end
    end
  end
end
