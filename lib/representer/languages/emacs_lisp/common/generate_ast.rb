# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the forms that the Emacs Lisp reader gives, and marks the names that each
# form defines.
module Representer::Languages::EmacsLisp::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, because the node types already show them.
    # [1 2]  ->  (vector 1 2)
    strip_tokens "(", ")", "[", "]", "#[", "#(", "#s(hash-table"

    # Label the first item of each list as its head, so that the import
    # `(require {{...}})` matches `(require 'cl-lib)`, and doesn't match
    # `(list 1 require)`.
    lists_are :list

    # The reader reads each of these marks as a list that starts with the
    # symbol given.
    MARKS = { "'" => "quote", "`" => "`", "#'" => "function", "," => ",", ",@" => ",@" }.freeze

    STRING_ESCAPES = { '\\\\' => "\\", '\"' => '"', '\n' => "\n", '\t' => "\t", "\\\n" => "", '\ ' => "" }.freeze
    CHARACTER_ESCAPES = { '\s' => " ", '\n' => "\n", '\t' => "\t" }.freeze
    CHARACTER_NAMES = { " " => '?\s', "\n" => '?\n', "\t" => '?\t' }.freeze
    RADIXES = { "x" => 16, "o" => 8, "b" => 2 }.freeze

    FUNCTION_FORMS = ["defun", "defsubst", "defmacro", "define-inline", "cl-defun", "cl-defsubst", "cl-defmacro",
                      "cl-defgeneric", "cl-defmethod"].freeze
    GLOBAL_VARIABLE_FORMS = ["defvar", "defvar-local", "defconst", "defcustom"].freeze
    QUOTED_NAME_FORMS = ["defalias", "define-error"].freeze
    LET_FORMS = ["let", "let*", "letrec", "dlet", "if-let*", "when-let*", "and-let*"].freeze
    SINGLE_BINDING_LET_FORMS = ["if-let", "when-let"].freeze
    LOOP_VARIABLE_FORMS = ["dolist", "dotimes", "cl-dolist", "cl-dotimes", "seq-doseq"].freeze
    VARIABLE_LIST_FORMS = ["seq-let", "cl-destructuring-bind", "cl-multiple-value-bind"].freeze
    LOCAL_FUNCTION_FORMS = ["cl-flet", "cl-flet*", "cl-labels", "cl-macrolet"].freeze
    LOOP_FORMS = ["cl-loop", "loop"].freeze
    LOOP_KEYWORDS = ["for", "as", "with", "into"].freeze

    def call
      tree.tap do
        write_numbers_as_their_values!
        write_strings_as_their_values!
        write_characters_as_their_values!
        write_every_symbol_as_a_leaf!
        write_every_form_as_a_list!
        write_quotes_as_lists!
        write_the_empty_list_as_nil!
        forget_field_names!
        mark_the_names_each_form_defines!
      end
    end

    private
    ### Values ###

    # Write each number as its value. A float that is minus zero, infinite
    # or not a number keeps its text.
    #
    # 1.  ->  1
    # +7  ->  7
    # #x1F  ->  31
    # #24r1k  ->  44
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless ["integer", "float"].include?(node.type) && node.leaf?

        value = node.type == "integer" ? integer(node.text) : decimal(node.text)
        node.text = value if value
      end
    end

    def integer(text)
      case text
      when /\A([-+]?\d+)\.?\z/ then Regexp.last_match(1).to_i.to_s
      when /\A#([xob])([-+]?\h+)\z/i
        Integer(Regexp.last_match(2), RADIXES.fetch(Regexp.last_match(1).downcase), exception: false)&.to_s
      when /\A#(\d\d?)r([-+]?\p{Alnum}+)\z/i
        base = Regexp.last_match(1).to_i
        Integer(Regexp.last_match(2), base, exception: false)&.to_s if base.between?(2, 36)
      end
    end

    def decimal(text)
      value = Representer::Engine::Numbers.decimal(text, separator: "")
      Representer::Engine::Numbers.write_decimal(value) if value && !(value.zero? && text.start_with?("-"))
    end

    # Turn each string into its value. Keep each escape not listed in
    # STRING_ESCAPES as a node of its own, so it can't make two different
    # strings the same.
    # "say \"hi\""  ->  say "hi"
    # "a\
    # b"  ->  ab
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.text[1...-1].scan(/\\.|[^\\]+/m).map do |piece|
          piece.start_with?("\\") ? STRING_ESCAPES.fetch(piece) { leaf(:escape_sequence, piece) } : piece
        end
        string_node(pieces)
      end
    end

    # Build a string from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    # Write each character as `?` and the character, because the reader
    # reads every spelling of a character as the same number. A character
    # with modifiers, such as `?\C-a`, or with an escape that isn't read
    # here keeps its text.
    # ?\(  ->  ?(
    # ?\x41  ->  ?A
    # ? followed by a space  ->  ?\s
    def write_characters_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "char" && node.leaf?

        value = character(node.text[1..])
        node.text = CHARACTER_NAMES.fetch(value) { "?#{value}" } if value
      end
    end

    def character(text)
      case text
      when /\A[^\\]\z/m then text
      when /\A\\[^\p{Alnum}]\z/ then text[1]
      when /\A\\(x\h+|u\h{4}|U\h{8})\z/
        value = text[2..].to_i(16)
        [value].pack("U") unless value.between?(0xD800, 0xDFFF) || value > 0x10FFFF
      else CHARACTER_ESCAPES[text]
      end
    end

    ### Forms ###

    # Write each symbol as a leaf. The grammar gives `nil`, `t`, `defun`,
    # `defsubst` and `defmacro` as tokens inside a symbol.
    def write_every_symbol_as_a_leaf!
      transform(tree, "(symbol) @symbol") { |match| leaf(:symbol, text_of(match.node)) unless match.node.leaf? }
    end

    # Write each special form and each definition as a list, with its first
    # word as a symbol, because the reader reads them all as lists.
    # (if a b)  ->  (list if a b)
    # (defun f (x) x)  ->  (list defun f (list x) x)
    def write_every_form_as_a_list!
      each_node(tree) do |node, _|
        next unless ["special_form", "function_definition", "macro_definition"].include?(node.type)

        node.type = "list"
        head = node.children.find { |child| !child.named? && child.type != "(" }
        node.replace_child(head, leaf(:symbol, head.text))
      end
    end

    # Write each quote, backquote, function quote and unquote as the list
    # that the reader gives.
    # 'x  ->  (list quote x)
    # #'car  ->  (list function car)
    # `(a ,b ,@c)  ->  (list ` (list a (list , b) (list ,@ c)))
    def write_quotes_as_lists!
      transform(tree, "[(quote) (function_quote) (unquote) (unquote_splice)] @mark") do |match|
        mark = match.node.children.find { |child| !child.named? }
        build(:list, leaf(:symbol, MARKS.fetch(mark.text)), *match.node.named_children)
      end
    end

    # Write `()` as `nil`, because the reader reads them as the same symbol.
    # (defun f () nil)  ->  (list defun f nil nil)
    def write_the_empty_list_as_nil!
      transform(tree, "(list) @list") { |match| leaf(:symbol, "nil") if match.node.named_children.empty? }
    end

    # Forget the grammar's field names, because the reader gives every item
    # of a form the same way.
    def forget_field_names!
      tree.each_descendant { |node| node.field = nil }
    end

    ### Names ###

    # Wrap each name that a form defines in a `definition` or `variable`
    # node, so that representation/spec.rb can list them in
    # names_are_defined_by.
    # (defun area (w) w)  ->  (list defun (definition area) (list (variable w)) w)
    # (let ((x 1)) x)  ->  (list let (list (list (variable x) 1)) x)
    def mark_the_names_each_form_defines!
      each_node(tree) { |node, _| mark_form!(node) if node.type == "list" }
    end

    def mark_form!(list)
      head, *args = list.named_children
      return unless symbol?(head)

      case head.text
      when *FUNCTION_FORMS then mark_function!(list, args)
      when "lambda" then mark_lambda_list!(args.first)
      when *GLOBAL_VARIABLE_FORMS then wrap!(list, args.first, :definition)
      when *QUOTED_NAME_FORMS then mark_quoted_name!(args.first)
      when *LET_FORMS then mark_bindings!(args.first)
      when *SINGLE_BINDING_LET_FORMS then mark_single_binding_or_bindings!(args.first)
      when "named-let" then mark_named_let!(list, args)
      when *LOOP_VARIABLE_FORMS then mark_first_symbol!(args.first)
      when *VARIABLE_LIST_FORMS then mark_every_symbol!(args.first)
      when *LOCAL_FUNCTION_FORMS then mark_local_functions!(args.first)
      when "condition-case" then wrap!(list, args.first, :variable)
      when *LOOP_FORMS then mark_loop_variables!(list, args)
      when "cl-defstruct" then mark_structure!(list, args)
      when "defclass" then mark_class!(list, args)
      end
    end

    def symbol?(node) = node&.type == "symbol"
    def list?(node) = node&.type == "list"
    def lambda_list_keyword?(node) = symbol?(node) && node.text.start_with?("&")

    # Wrap a symbol in a node of the type given. `nil` and `t` are constants,
    # so they never name anything.
    def wrap!(parent, node, type)
      return unless symbol?(node) && !["nil", "t", "."].include?(node.text) && !lambda_list_keyword?(node)

      parent.replace_child(node, build(type, node))
    end

    # Mark a function's name and its lambda list. A method's lambda list
    # comes after its qualifiers, such as `:before`.
    # (cl-defmethod area :before ((s square)) ...) defines area and s.
    def mark_function!(list, args)
      name, *rest = args
      wrap!(list, name, :definition)
      mark_lambda_list!(rest.find { |arg| !(symbol?(arg) && arg.text.start_with?(":")) })
    end

    # Mark each variable of a lambda list, including the variable, the
    # keyword's variable and the flag of `(x 5 x-given)`, `((:key x) 5)` and
    # a method's `(x integer)`.
    def mark_lambda_list!(lambda_list)
      return unless list?(lambda_list)

      lambda_list.named_children.each do |parameter|
        if symbol?(parameter)
          wrap!(lambda_list, parameter, :variable)
        elsif list?(parameter)
          first, _, flag = parameter.named_children
          list?(first) ? wrap!(first, first.named_children.last, :variable) : wrap!(parameter, first, :variable)
          wrap!(parameter, flag, :variable)
        end
      end
    end

    # (defalias 'name #'other) defines name.
    def mark_quoted_name!(form)
      return unless list?(form) && form.named_children.first&.text == "quote"

      wrap!(form, form.named_children[1], :definition)
    end

    # Mark a symbol, or the first symbol of a binding such as `(x 1)`.
    def mark_binding!(parent, binding, type = :variable)
      list?(binding) ? wrap!(binding, binding.named_children.first, type) : wrap!(parent, binding, type)
    end

    # (let ((x 1) y) ...) defines x and y.
    def mark_bindings!(bindings)
      bindings.named_children.each { |binding| mark_binding!(bindings, binding) } if list?(bindings)
    end

    # (if-let (x (f)) ...) defines x, and (if-let ((x (f)) (y (g))) ...)
    # defines x and y.
    def mark_single_binding_or_bindings!(spec)
      return unless list?(spec)

      first, second, *rest = spec.named_children
      symbol?(first) && second && rest.empty? ? wrap!(spec, first, :variable) : mark_bindings!(spec)
    end

    # (named-let walk ((x 1)) ...) defines walk and x.
    def mark_named_let!(list, args)
      wrap!(list, args.first, :variable)
      mark_bindings!(args[1])
    end

    # (dolist (x list) ...) defines x.
    def mark_first_symbol!(spec)
      wrap!(spec, spec.named_children.first, :variable) if list?(spec)
    end

    # (seq-let (a b &rest c) list ...) defines a, b and c.
    def mark_every_symbol!(pattern)
      return unless list?(pattern)

      each_node(pattern) { |node, parent| wrap!(parent, node, :variable) if parent }
    end

    # (cl-flet ((helper (x) ...)) ...) defines helper and x.
    def mark_local_functions!(functions)
      return unless list?(functions)

      functions.named_children.each do |function|
        next unless list?(function)

        name, lambda_list = function.named_children
        wrap!(function, name, :variable)
        mark_lambda_list!(lambda_list)
      end
    end

    # Mark the variable after each `for`, `as`, `with` and `into` of a loop,
    # and every symbol of a list in that place.
    # (cl-loop for (a b) in pairs collect a into firsts) defines a, b and firsts.
    def mark_loop_variables!(loop, args)
      args.each_cons(2) do |keyword, variable|
        next unless symbol?(keyword) && LOOP_KEYWORDS.include?(keyword.text)

        list?(variable) ? mark_every_symbol!(variable) : wrap!(loop, variable, :variable)
      end
    end

    # (cl-defstruct point x (y 0)) defines point, x and y.
    def mark_structure!(list, args)
      name, *slots = args
      list?(name) ? wrap!(name, name.named_children.first, :definition) : wrap!(list, name, :definition)
      slots.each { |slot| mark_binding!(list, slot, :definition) }
    end

    # (defclass shape () ((side :accessor shape-side))) defines shape, the
    # slot side and its accessor.
    def mark_class!(list, args)
      name, _, slots = args
      wrap!(list, name, :definition)
      return unless list?(slots)

      slots.named_children.each do |slot|
        mark_binding!(slots, slot, :definition)
        next unless list?(slot)

        slot.named_children.each_cons(2) do |option, value|
          wrap!(slot, value, :definition) if [":accessor", ":reader", ":writer"].include?(option.text)
        end
      end
    end
  end
end
