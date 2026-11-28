# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to declarations that Go reads the same way.
module Representer::Languages::Go::Representation
  class Normalise < Representer::Engine::Normalise
    # Drop the package clause, because every file of a solution must be in
    # the package that its tests use.
    # package leap  ->
    drop "package {{...}}"

    # Literals of these kinds have the type as their own, so `var a int = 1`
    # is `a := 1`, and `var a int8 = 1` is `a := int8(1)`.
    LITERALS = {
      "string" => ["literal", "interpreted_string_literal"],
      "bool" => ["true", "false"],
      "int" => ["int_literal"],
      "float64" => ["float_literal"],
      "complex128" => ["imaginary_literal"],
      "rune" => ["rune_literal"]
    }.freeze

    OTHER_NUMBER_TYPES = [
      "int8", "int16", "int32", "int64", "uint", "uint8", "uint16", "uint32", "uint64", "uintptr", "byte", "float32",
      "complex64"
    ].freeze

    # A built-in type missing from here has the zero value `T(0)`.
    ZEROS = {
      "string" => ["literal", ""],
      "bool" => ["false", "false"],
      "int" => ["int_literal", "0"],
      "float64" => ["float_literal", "0.0"],
      "complex128" => ["imaginary_literal", "0i"]
    }.freeze

    # A type missing from here keeps its `var` declaration.
    STANDARD_TYPES = {
      "strings.Builder" => :composite,
      "strings.Reader" => :composite,
      "bytes.Buffer" => :composite,
      "bytes.Reader" => :composite,
      "sync.Mutex" => :composite,
      "sync.RWMutex" => :composite,
      "sync.WaitGroup" => :composite,
      "sync.Once" => :composite,
      "sync.Map" => :composite,
      "sync.Pool" => :composite,
      "sync.Cond" => :composite,
      "time.Time" => :composite,
      "list.List" => :composite,
      "big.Int" => :composite,
      "big.Float" => :composite,
      "big.Rat" => :composite,
      "atomic.Int32" => :composite,
      "atomic.Int64" => :composite,
      "atomic.Uint32" => :composite,
      "atomic.Uint64" => :composite,
      "atomic.Bool" => :composite,
      "atomic.Value" => :composite,
      "regexp.Regexp" => :composite,
      "bufio.Scanner" => :composite,
      "tabwriter.Writer" => :composite,
      "time.Duration" => :number,
      "time.Month" => :number,
      "time.Weekday" => :number,
      "os.FileMode" => :number,
      "reflect.Kind" => :number,
      "token.Token" => :number
    }.freeze

    def call
      super.tap do |root|
        split_grouped_types_and_variables!(root)
        write_each_local_var_as_a_short_declaration!(root)
      end
    end

    private
    ### Grouped declarations ###

    # Write each type and variable of a group at the top of the file as a
    # declaration of its own. Keep a group of constants whole, because
    # `iota` and a repeated value depend on the group.
    # type (A int; B string)  ->  type A int; type B string
    def split_grouped_types_and_variables!(root)
      root.children = root.children.flat_map do |declaration|
        next [declaration] unless ["type_declaration", "var_declaration"].include?(declaration.type)

        declaration.named_children.map { |spec| build(declaration.type, spec) }
      end
    end

    ### Local variables ###

    # Write each `var` inside a function as a `:=`, with the value that the
    # `var` gives. Keep a `var` if its type has no zero value that can be
    # written without the type, such as a slice's.
    #
    # var a int  ->  a := 0
    # var a, b = 1, 2  ->  a := 1; b := 2
    # var a float64 = 1  ->  a := float64(1)
    # var d time.Duration  ->  d := time.Duration(0)
    # type T struct{}; var t T  ->  type T struct{}; t := T{}
    def write_each_local_var_as_a_short_declaration!(root)
      types = defined_types(root)
      each_node(root) do |node, _|
        next unless node.type == "statement_list"

        node.children = node.children.flat_map { |statement| short_declarations(statement, types) || [statement] }
      end
    end

    # Return the definition of each type defined at the top of the file,
    # by name. Leave out a type with type parameters.
    def defined_types(root)
      specs = root.children.select { |child| child.type == "type_declaration" }.flat_map(&:named_children)
      specs.select { |spec| spec.type == "type_spec" && spec[:type_parameters].nil? }.to_h do |spec|
        [spec[:name].text, spec[:type]]
      end
    end

    # Return the `:=` statements that replace a `var` statement, or nil if
    # any of its variables can't be written with `:=`.
    def short_declarations(statement, types)
      return nil unless statement.type == "var_declaration"

      statements = statement.named_children.map { |spec| short_declarations_of_spec(spec, types) }
      statements.all? ? statements.flatten : nil
    end

    # Keep a `var` that gives several variables values that read one of
    # them, because `var a, b = 1, a` reads an outer `a`, and
    # `a := 1; b := a` wouldn't.
    def short_declarations_of_spec(spec, types)
      names = spec[:name].children
      values = spec[:value]&.named_children || []
      return nil if names.any? { |name| name.type == "blank_identifier" }
      return nil unless values.empty? || values.size == names.size
      return nil if names.size > 1 && values.any? { |value| mentions?(value, names.map(&:text)) }

      names.each_with_index.map do |name, index|
        value = value_for(spec[:type], values[index], types)
        return nil unless value

        build(:short_var_declaration,
          { left: build(:identifier_list, name) }, token(":="), { right: build(:expression_list, value) })
      end
    end

    def mentions?(node, names)
      node.each_descendant { |descendant| return true if descendant.leaf? && names.include?(descendant.text) }
      false
    end

    # Return the value that `var x type = value` gives x, written so that it
    # has the type without the declaration, or nil if that can't be done.
    def value_for(type, value, types)
      return value unless type
      return standard_value(type, value) if type.type == "qualified_type"
      return nil unless type.type == "type_identifier"

      name = type.text
      return builtin?(name) ? builtin_zero(name) : defined_zero(name, types) unless value
      return value if LITERALS.fetch(name, []).include?(value.type)
      return value if value.type == "call_expression" && value[:function]&.text == name
      return value if value.type == "composite_literal" && value[:type]&.text == name

      conversion(leaf(:identifier, name), value)
    end

    def builtin?(name) = LITERALS.key?(name) || OTHER_NUMBER_TYPES.include?(name)

    def builtin_zero(name)
      return conversion(leaf(:identifier, name), zero) unless ZEROS.key?(name)

      type, text = ZEROS[name]
      type == "literal" ? literal(text) : leaf(type, text)
    end

    # var sb strings.Builder  ->  sb := strings.Builder{}
    # var sb strings.Builder = strings.Builder{}  ->  sb := strings.Builder{}
    def standard_value(type, value)
      name = qualified_name(type)
      kind = STANDARD_TYPES[name]
      return nil unless kind
      return value.type == "composite_literal" && qualified_name(value[:type]) == name ? value : nil if value
      return composite(type) if kind == :composite

      function = build(:selector_expression,
        { operand: leaf(:identifier, type[:package].text) }, { field: leaf(:field_identifier, type[:name].text) })
      conversion(function, zero)
    end

    def qualified_name(type) = type&.type == "qualified_type" ? "#{type[:package].text}.#{type[:name].text}" : nil

    # Return the zero value of a type defined in the file, as `T{}` or as a
    # conversion such as `T(0)`, or nil if it isn't known.
    def defined_zero(name, types)
      return nil unless types.key?(name)

      zero = underlying_zero(types[name], types, [name])
      case zero
      when nil then nil
      when :composite then composite(leaf(:type_identifier, name))
      else conversion(leaf(:identifier, name), zero)
      end
    end

    # Return :composite for a type whose zero value is written `T{}`, or the
    # zero value to convert, such as 0 or nil. Follow a type defined in
    # terms of another defined type.
    def underlying_zero(type, types, seen)
      case type.type
      when "struct_type", "array_type" then :composite
      when "slice_type", "map_type", "pointer_type", "function_type", "channel_type", "interface_type" then leaf(:nil, "nil")
      when "qualified_type"
        STANDARD_TYPES[qualified_name(type)]&.then { |kind| kind == :composite ? :composite : zero }
      when "type_identifier" then named_zero(type.text, types, seen)
      end
    end

    def named_zero(name, types, seen)
      if builtin?(name)
        ZEROS.key?(name) ? builtin_zero(name) : zero
      elsif ["error", "any"].include?(name)
        leaf(:nil, "nil")
      elsif types.key?(name) && !seen.include?(name)
        underlying_zero(types[name], types, seen + [name])
      end
    end

    def zero = leaf(:int_literal, "0")

    def composite(type) = build(:composite_literal, { type: copy(type) }, { body: build(:literal_value) })

    def conversion(function, value)
      build(:call_expression, { function: }, { arguments: build(:argument_list, value) })
    end
  end
end
