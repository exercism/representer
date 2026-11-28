# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the forms that Common Lisp's own reader gives, and marks the names that
# each form defines.
module Representer::Languages::CommonLisp::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, quote marks and package colons, because the node
    # types already show them.
    # '(a b)  ->  (quoting_lit (list_lit a b))
    strip_tokens "(", ")", "'", "`", ",", ",@", "#'", ":", "::"

    RADIXES = { "x" => 16, "o" => 8, "b" => 2 }.freeze

    LET_FORMS = ["let", "let*", "do", "do*", "prog", "prog*"].freeze
    VARIABLE_LIST_FORMS = ["multiple-value-bind", "destructuring-bind"].freeze
    LOOP_VARIABLE_FORMS = ["dolist", "dotimes", "do-symbols", "do-external-symbols", "with-open-file",
                           "with-open-stream", "with-output-to-string", "with-input-from-string"].freeze
    LOCAL_FUNCTION_FORMS = ["flet", "labels", "macrolet"].freeze
    GLOBAL_VARIABLE_FORMS = ["defvar", "defparameter", "defconstant", "deftype"].freeze
    CLASS_FORMS = ["defclass", "define-condition"].freeze
    ACCESSOR_OPTIONS = ["accessor", "reader", "writer"].freeze

    def call
      tree.tap do
        write_numbers_as_their_values!
        fold_every_symbol_to_lower_case!
        write_strings_as_their_values!
        write_nil_and_the_empty_list_as_nil!
        write_quote_and_function_forms_with_their_marks!
        drop_the_cl_package_from_symbols!
        give_the_options_of_defpackage_a_node_of_their_own!
        mark_the_names_each_form_defines!
      end
    end

    private
    ### Values ###

    # Write each number as its value. A float with an exponent marker other
    # than `e` keeps its text, because the marker gives the float's type.
    #
    # #x1F  ->  31
    # +7  ->  7
    # 7.  ->  7
    # 2/4  ->  1/2
    # 1.50  ->  1.5
    # 1.0d0  ->  1.0d0
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "num_lit" && node.leaf?

        value = number(node.text)
        node.text = value if value
      end
    end

    def number(text)
      case text
      when /\A#([xob])([-+]?\h+)\z/i
        Integer(Regexp.last_match(2), RADIXES.fetch(Regexp.last_match(1).downcase), exception: false)&.to_s
      when /\A([-+]?\d+)\.?\z/ then Regexp.last_match(1).to_i.to_s
      when %r{\A([-+]?\d+)/(\d+)\z} then ratio(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
      when /\A[-+]?(\d*\.\d+(e[-+]?\d+)?|\d+(\.\d*)?e[-+]?\d+)\z/i
        value = Representer::Engine::Numbers.decimal(text.delete_prefix("+"), separator: "")
        value && Representer::Engine::Numbers.write_decimal(value)
      end
    end

    # Write a ratio in its lowest terms, and as an integer if it is one.
    # 4/2  ->  2
    def ratio(numerator, denominator)
      return nil if denominator.zero?

      value = Rational(numerator, denominator)
      value.denominator == 1 ? value.numerator.to_s : "#{value.numerator}/#{value.denominator}"
    end

    # Fold every symbol to lower case, because the reader folds every symbol
    # to one case. A symbol written between bars keeps its case.
    # (Defun Add-One (X) X)  ->  (defun add-one (x) x)
    def fold_every_symbol_to_lower_case!
      each_node(tree) do |node, _|
        next unless ["sym_lit", "kwd_symbol", "defun_keyword", "accumulation_verb"].include?(node.type)
        next unless node.leaf? && !node.text.include?("|")

        node.text = node.text.downcase
      end
    end

    # Turn each string into its value. Only a backslash and a quote can be
    # escaped.
    # "say \"hi\""  ->  say "hi"
    def write_strings_as_their_values!
      transform(tree, "(str_lit) @string") { |match| literal(match.node.text[1...-1].gsub(/\\(.)/m, '\1')) }
    end

    # Write `NIL` and `()` as `nil`, because the reader reads them as the
    # same object.
    # NIL  ->  nil
    # ()  ->  nil
    def write_nil_and_the_empty_list_as_nil!
      transform(tree, '(sym_lit "nil")') { |_match| leaf(:nil_lit, "nil") }
      transform(tree, "(list_lit) @list") { |match| leaf(:nil_lit, "nil") if match.node.named_children.empty? }
    end

    # Write `(quote x)` as `'x` and `(function x)` as `#'x`, because the
    # reader reads `'x` as `(quote x)` and `#'x` as `(function x)`.
    # (quote (1 2))  ->  '(1 2)
    # (function car)  ->  #'car
    def write_quote_and_function_forms_with_their_marks!
      transform(tree, '(list_lit (sym_lit /\A(quote|function)\z/) @head (_) @form)') do |match|
        next unless match.node.named_children.size == 2

        build(match[:head].text == "quote" ? :quoting_lit : :var_quoting_lit, match[:form])
      end
    end

    # Drop the `cl` package from a symbol, because the reader reads
    # `cl:car` as the same symbol as `car`.
    # cl:car  ->  car
    # common-lisp:car  ->  car
    def drop_the_cl_package_from_symbols!
      transform(tree, "(package_lit symbol: (_) @symbol) @package") do |match|
        match[:symbol] if ["cl", "common-lisp"].include?(match.node["package"]&.text&.downcase)
      end
    end

    ### Containers ###

    # Put the options of each `defpackage` in a `package_options` node, so
    # that Reorder can sort them.
    # (defpackage :p (:shadow :x))  ->  (defpackage :p (package_options (:shadow :x)))
    def give_the_options_of_defpackage_a_node_of_their_own!
      each_node(tree) do |list, _|
        next unless list.type == "list_lit" && head(list) == "defpackage"

        options = list.named_children[2..] || []
        list.children.reject! { |child| options.any? { |option| option.equal?(child) } }
        list.children << build(:package_options, *options)
      end
    end

    ### Names ###

    # Wrap each name that a form defines in a `definition` or `variable`
    # node, so that representation/spec.rb can list them in
    # names_are_defined_by. The forms are functions, macros and methods
    # with their lambda lists, loops, local bindings, global variables,
    # structures, classes, condition handlers and packages.
    #
    # (defun area (w) w)  ->  (defun (definition area) ((variable w)) w)
    # (let ((x 1)) x)  ->  (let (((variable x) 1)) x)
    def mark_the_names_each_form_defines!
      each_node(tree) do |node, _|
        case node.type
        when "defun" then mark_function!(node)
        when "for_clause", "with_clause" then mark_loop_variable!(node)
        when "list_lit" then mark_form!(node)
        end
      end
    end

    def head(list) = list.named_children.first&.then { |node| symbol?(node) ? node.text : nil }

    def symbol?(node) = node&.type == "sym_lit"

    def lambda_list_keyword?(node) = symbol?(node) && node.text.start_with?("&")

    def wrap!(parent, node, type)
      parent.replace_child(node, build(type, node)) if symbol?(node)
    end

    # Wrap a symbol, or the first symbol of a binding such as `(x 1)`.
    def mark_binding!(parent, node, type)
      return unless node

      node.type == "list_lit" ? wrap!(node, node.named_children.first, type) : wrap!(parent, node, type)
    end

    def mark_bindings!(list, type)
      return unless list&.type == "list_lit"

      list.named_children.each { |binding| mark_binding!(list, binding, type) }
    end

    ### Functions ###

    # Mark the name of a function, macro or method, including `(setf name)`,
    # and the variables of its lambda list.
    def mark_function!(defun)
      header = defun.children.find { |child| child.type == "defun_header" }
      return unless header

      name = header["function_name"]
      if symbol?(name)
        wrap!(header, name, :definition)
      elsif name&.type == "list_lit" && head(name) == "setf"
        mark_binding!(name, name.named_children.last, :definition)
      end
      mark_lambda_list!(header["lambda_list"])
    end

    def mark_lambda_list!(list)
      return unless list&.type == "list_lit"

      section = :required
      list.named_children.each do |element|
        if lambda_list_keyword?(element)
          section = element.text
        elsif symbol?(element)
          wrap!(list, element, :variable)
        elsif element.type == "list_lit" && section != :required && (bare = bare_variable(element))
          wrap!(list, list.replace_child(element, bare), :variable)
        elsif element.type == "list_lit"
          mark_list_element!(element, section)
        end
      end
    end

    # Return the variable of `(n nil)` or `(n)`, which mean `n` in the lists
    # where a variable can have a default.
    def bare_variable(element)
      first, second, third = element.named_children
      first if symbol?(first) && third.nil? && (second.nil? || second.type == "nil_lit")
    end

    # Mark the variables of `(x integer)` (a variable and its specialiser),
    # `(n 5 given)` (a variable, a default and a flag) and `((:key name) 5)`
    # (a keyword argument).
    def mark_list_element!(element, section)
      first, second, third = element.named_children
      if symbol?(first)
        wrap!(element, first, :variable)
      elsif first&.type == "list_lit"
        mark_binding!(first, first.named_children.last, :variable)
      end
      wrap!(element, third, :variable) if section != "&aux" && second
    end

    # Mark the variable of a loop's `for` or `with` clause.
    # for x in xs  ->  for (variable x) in xs
    def mark_loop_variable!(clause)
      variable = clause.type == "for_clause" ? clause["variable"] : clause.children.find { |child| symbol?(child) }
      wrap!(clause, variable, :variable)
    end

    ### Forms that bind or define names ###

    def mark_form!(list)
      forms = list.named_children
      case head(list)
      when *LET_FORMS then mark_bindings!(forms[1], :variable)
      when *VARIABLE_LIST_FORMS then mark_every_symbol!(forms[1])
      when *LOOP_VARIABLE_FORMS then mark_binding_of_list!(forms[1])
      when *LOCAL_FUNCTION_FORMS then mark_local_functions!(forms[1])
      when *GLOBAL_VARIABLE_FORMS then mark_binding!(list, forms[1], :definition)
      when "defstruct" then mark_structure!(list, forms[1..])
      when *CLASS_FORMS then mark_class!(list, forms[1..])
      when "handler-case" then mark_handlers!(forms[2..])
      when "defpackage" then mark_package_name!(list)
      end
    end

    # (multiple-value-bind (a b) (values 1 2) a) defines a and b.
    def mark_every_symbol!(list)
      return unless list&.type == "list_lit"

      each_node(list) { |node, parent| wrap!(parent, node, :variable) unless lambda_list_keyword?(node) }
    end

    # (dolist (x list) ...) defines x.
    def mark_binding_of_list!(list)
      mark_binding!(list, list.named_children.first, :variable) if list&.type == "list_lit"
    end

    # (flet ((helper (x) ...)) ...) defines helper and x.
    def mark_local_functions!(list)
      return unless list&.type == "list_lit"

      list.named_children.each do |function|
        next unless function.type == "list_lit"

        name, lambda_list = function.named_children
        wrap!(function, name, :variable)
        mark_lambda_list!(lambda_list)
      end
    end

    # (defstruct point x (y 0)) defines point, x and y.
    def mark_structure!(list, forms)
      return if forms.empty?

      mark_binding!(list, forms.first, :definition)
      forms[1..].each { |slot| mark_binding!(list, slot, :definition) unless slot.type == "literal" }
    end

    # (defclass shape (parent) ((side :accessor side))) defines shape, the
    # slot side and its accessor.
    def mark_class!(list, forms)
      return if forms.empty?

      mark_binding!(list, forms.first, :definition)
      slots = forms[2]
      return unless slots&.type == "list_lit"

      slots.named_children.each do |slot|
        next unless slot.type == "list_lit"

        mark_binding!(slots, slot, :definition)
        slot.named_children.each_cons(2) do |option, value|
          wrap!(slot, value, :definition) if ACCESSOR_OPTIONS.include?(keyword_text(option))
        end
      end
    end

    # (handler-case form (error (e) ...)) defines e.
    def mark_handlers!(clauses)
      clauses.each { |clause| mark_binding_of_list!(clause.named_children[1]) if clause.type == "list_lit" }
    end

    # (defpackage :two-fer ...) defines two-fer.
    def mark_package_name!(list)
      list.named_children.each do |keyword|
        next unless keyword.type == "kwd_lit"

        name = keyword.named_children.first
        keyword.replace_child(name, build(:definition, name)) if name&.type == "kwd_symbol"
      end
    end

    def keyword_text(node) = node.type == "kwd_lit" ? node.named_children.first&.text : nil
  end
end
