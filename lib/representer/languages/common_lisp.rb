module Representer
  module Languages
    # Every step of exercism/common-lisp-representer is a rule here. The old
    # representer ran the code through SBCL's reader and replaced the package
    # name, the exports, the names of functions defined with `defun` and their
    # lambda-list variables with generated keywords. Here every name that the
    # solution defines is renamed, wherever it is defined (functions, macros,
    # variables, structures, classes and local bindings), and the reader's
    # case folding is applied to every name.
    class CommonLisp < Language
      tracks "common-lisp"
      version 2
      grammar "common_lisp"
      extensions ".lisp"

      # The grammar has one `sym_lit` type for every symbol. The rewrites
      # below give a name that the student defines for a variable the
      # `variable` type, and a name defined for a function, macro, global
      # variable, structure or class the `definition` type, so that the rename
      # rules can find them.
      names :sym_lit, :kwd_symbol, :variable, :definition

      # A character such as #\a has only its `#` as a child, and a string's
      # text is left out of the tree.
      text_nodes :char_lit, :str_lit

      ### Drop ###

      drop "[(comment) (block_comment)]"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "'", "`", ",", ",@", "#'", ":", "::"

      ### Rewrite ###

      # The reader folds every symbol to upper case, so `Name` and `name` are
      # the same symbol. A symbol written between bars keeps its case.
      rewrite "[(sym_lit) @symbol (kwd_symbol) @symbol (defun_keyword) @symbol (accumulation_verb) @symbol]",
        where: ->(match) { CommonLisp.foldable?(match[:symbol]) } do |match|
        leaf(match[:symbol].type, match[:symbol].text.downcase)
      end

      # `:common-lisp` is `:cl`, and `#:name` and `:name` name the same thing.
      rewrite '(kwd_symbol "common-lisp") @symbol' do |_match|
        leaf(:kwd_symbol, "cl")
      end
      rewrite '(list_lit "#") @list' do |match|
        CommonLisp.drop_uninterned_marks(match.node) ? match.node : nil
      end

      # `NIL`, `()` and `'()` are the same value.
      rewrite '(sym_lit "nil") @nil' do |_match|
        leaf(:nil_lit, "nil")
      end
      rewrite "(list_lit) @list", where: ->(match) { match.node.children.empty? } do |_match|
        leaf(:nil_lit, "nil")
      end
      rewrite "(quoting_lit (nil_lit) @nil)", "@nil"

      # `(quote x)` is `'x` and `(function x)` is `#'x`.
      rewrite '(list_lit (sym_lit "quote") (_) @form)', where: ->(match) { CommonLisp.two_forms?(match) } do |match|
        build(:quoting_lit, match[:form])
      end
      rewrite '(list_lit (sym_lit "function") (_) @form)', where: ->(match) { CommonLisp.two_forms?(match) } do |match|
        build(:var_quoting_lit, match[:form])
      end

      # `#'(lambda (x) x)` is `(lambda (x) x)`.
      rewrite "(var_quoting_lit (list_lit (defun (defun_header (defun_keyword \"lambda\")))) @lambda)", "@lambda"

      # `cl:car` is `car`.
      rewrite "(package_lit symbol: (_) @symbol) @package",
        where: ->(match) { %w[cl common-lisp].include?(match.node["package"]&.text&.downcase) } do |match|
        match[:symbol]
      end

      # A string is its value. Only a backslash and a quote can be escaped.
      rewrite "(str_lit) @string", where: ->(match) { match.node.leaf? } do |match|
        literal(match.node.text[1...-1].gsub(/\\(.)/m, '\1'))
      end

      # A docstring is a comment. A string is only a docstring if more forms
      # follow it, because otherwise it is the value that the function returns.
      rewrite "(defun) @defun" do |match|
        CommonLisp.drop_docstring(match.node) { |form| form.type == "literal" } ? match.node : nil
      end
      rewrite '(list_lit (sym_lit /\A(defvar|defparameter|defconstant)\z/)) @list' do |match|
        CommonLisp.drop_variable_docstring(match.node) ? match.node : nil
      end

      # The options of `defpackage` can come in any order.
      rewrite '(list_lit (sym_lit "defpackage")) @list' do |match|
        CommonLisp.sort_package_options(match.node) ? match.node : nil
      end

      ### Variables and definitions ###

      rewrite "(defun) @defun" do |match|
        CommonLisp.mark_function(match.node) ? match.node : nil
      end
      rewrite "(for_clause variable: (sym_lit) @name)" do |match|
        CommonLisp.retype(match[:name], :variable)
      end
      rewrite "(with_clause (sym_lit) @name)" do |match|
        CommonLisp.retype(match[:name], :variable)
      end
      rewrite "(list_lit (sym_lit)) @list" do |match|
        CommonLisp.mark_form(match.node) ? match.node : nil
      end

      ### Rename and keep ###

      rename "(variable) @name"
      rename_member "(definition) @name"

      # The name of a package is a keyword, and so are the names in its
      # `:export` and `:use` options. A keyword is only renamed if the
      # solution defines something with that name.
      rename_member '(list_lit (sym_lit "defpackage") (kwd_lit (kwd_symbol) @name))'
      member "(kwd_lit (kwd_symbol) @name)"

      # `pkg:name` refers to a definition in another package.
      member "(package_lit symbol: (sym_lit) @name)"

      keep "&optional", "&key", "&rest", "&body", "&aux", "&whole", "&environment", "&allow-other-keys"

      # The forms below bind or define names. Each handler gives the names the
      # type that its rename rule looks for.
      LAMBDA_LIST_KEYWORDS = /\A&/
      LET_FORMS = %w[let let* do do* prog prog*].freeze
      VARIABLE_LIST_FORMS = %w[multiple-value-bind destructuring-bind].freeze
      LOOP_VARIABLE_FORMS = %w[dolist dotimes do-symbols do-external-symbols with-open-file with-open-stream
                               with-output-to-string with-input-from-string].freeze
      LOCAL_FUNCTION_FORMS = %w[flet labels macrolet].freeze
      GLOBAL_VARIABLE_FORMS = %w[defvar defparameter defconstant deftype].freeze
      CLASS_FORMS = %w[defclass define-condition].freeze
      ACCESSOR_OPTIONS = %w[accessor reader writer].freeze

      class << self
        def foldable?(leaf) = leaf.leaf? && !leaf.text.include?("|") && leaf.text != leaf.text.downcase

        # A form with exactly a head and one argument.
        def two_forms?(match) = match.node.named_children.size == 2

        # Removes the `#` before a keyword, as in `#:name`.
        def drop_uninterned_marks(list)
          before = list.children.size
          list.children.each_with_index do |child, index|
            following = list.children[index + 1]
            list.children[index] = nil if child.type == "#" && following&.type == "kwd_lit"
          end
          list.children.compact!
          list.children.size != before
        end

        def retype(leaf, type)
          return nil unless leaf.leaf?

          leaf.type = type.to_s
          leaf
        end

        def head(list) = list.named_children.first&.then { |node| node.type == "sym_lit" ? node.text : nil }

        def symbol?(node) = node&.type == "sym_lit"

        # Gives a symbol, or the first symbol of a list such as `(x 1)`, the
        # type. Returns whether anything changed.
        def mark_binding(node, type)
          target = node.type == "list_lit" ? node.named_children.first : node
          return false unless symbol?(target)

          retype(target, type) && true
        end

        def mark_bindings(list, type)
          return false unless list&.type == "list_lit"

          list.named_children.map { |binding| mark_binding(binding, type) }.any?
        end

        ### Functions ###

        # The function's name, and its lambda list's variables.
        def mark_function(defun)
          header = defun.children.find { |child| child.type == "defun_header" }
          return false unless header

          changed = false
          name = header["function_name"]
          if symbol?(name)
            changed |= retype(name, :definition) && true
          elsif name&.type == "list_lit" && head(name) == "setf"
            changed |= mark_binding(name.named_children.last, :definition)
          end
          changed | mark_lambda_list(header["lambda_list"])
        end

        def mark_lambda_list(list)
          return false unless list&.type == "list_lit"

          section = :required
          changed = false
          list.named_children.each do |element|
            if element.type == "list_lit" && section != :required && (bare = bare_variable(element))
              list.replace_child(element, bare)
              changed = true
              changed |= retype(bare, :variable) && true
            elsif symbol?(element) && element.text.match?(LAMBDA_LIST_KEYWORDS)
              section = element.text
            elsif symbol?(element)
              changed |= retype(element, :variable) && true
            elsif element.type == "list_lit"
              changed |= mark_list_element(element, section)
            end
          end
          changed
        end

        # `(n nil)` and `(n)` are `n`, in the lists where a variable can have a default.
        def bare_variable(element)
          first, second, third = element.named_children
          return nil unless symbol?(first) && third.nil? && (second.nil? || second.type == "nil_lit")

          first
        end

        # `(x integer)` is a variable and its specialiser, `(n 5 given)` a
        # variable, a default and a flag, and `((:key name) 5)` a keyword
        # argument.
        def mark_list_element(element, section)
          first, second, third = element.named_children
          changed = false
          if symbol?(first)
            changed |= retype(first, :variable) && true
          elsif first&.type == "list_lit"
            changed |= mark_binding(first.named_children.last, :variable)
          end
          changed |= mark_binding(third, :variable) if symbol?(third) && section != "&aux" && second
          changed
        end

        ### Docstrings ###

        # Removes the docstring of a `defun`, if it has one.
        def drop_docstring(defun)
          return false if defun.role == :docstring_checked

          defun.role = :docstring_checked
          values = defun.children.select { |child| child.field == "value" }
          return false unless values.size > 1 && values.first.type == "literal"

          defun.children.delete_if { |child| child.equal?(values.first) }
          true
        end

        # `(defvar *x* 1 "doc")` and `(defparameter *x* 1 "doc")`.
        def drop_variable_docstring(list)
          return false if list.role == :docstring_checked

          list.role = :docstring_checked
          forms = list.named_children
          return false unless forms.size == 4 && forms.last.type == "literal"

          list.children.delete_if { |child| child.equal?(forms.last) }
          true
        end

        ### defpackage ###

        # Sorts the options by their keyword. Returns whether the order changed.
        def sort_package_options(list)
          options = list.children.select { |child| child.type == "list_lit" && option_key(child) }
          sorted = options.sort_by.with_index { |option, index| [option_key(option), index] }
          return false if options.map(&:object_id) == sorted.map(&:object_id)

          positions = list.children.each_index.select { |index| options.any? { |option| option.equal?(list.children[index]) } }
          positions.zip(sorted).each { |position, option| list.children[position] = option }
          true
        end

        def option_key(option)
          keyword = option.named_children.first
          keyword&.type == "kwd_lit" ? keyword.named_children.first&.text : nil
        end

        ### Forms that bind or define names ###

        def mark_form(list)
          forms = list.named_children
          name = head(list)
          case name
          when *LET_FORMS then mark_bindings(forms[1], :variable)
          when *VARIABLE_LIST_FORMS then mark_all_symbols(forms[1])
          when *LOOP_VARIABLE_FORMS then mark_binding_of_list(forms[1])
          when *LOCAL_FUNCTION_FORMS then mark_local_functions(forms[1])
          when *GLOBAL_VARIABLE_FORMS then mark_binding(forms[1], :definition)
          when "defstruct" then mark_structure(forms[1..])
          when *CLASS_FORMS then mark_class(forms[1..])
          when "handler-case" then mark_handlers(forms[2..])
          else false
          end
        end

        def mark_all_symbols(list)
          return false unless list&.type == "list_lit"

          changed = false
          list.each_descendant do |node|
            next unless symbol?(node) && !node.text.match?(LAMBDA_LIST_KEYWORDS)

            changed |= retype(node, :variable) && true
          end
          changed
        end

        # `(dolist (x list) ...)` binds x.
        def mark_binding_of_list(list)
          return false unless list&.type == "list_lit"

          mark_binding(list.named_children.first, :variable)
        end

        # `(flet ((helper (x) ...)) ...)` defines helper and its variables.
        def mark_local_functions(list)
          return false unless list&.type == "list_lit"

          changed = false
          list.named_children.each do |function|
            next unless function.type == "list_lit"

            name, lambda_list = function.named_children
            changed |= mark_binding(name, :variable) if symbol?(name)
            changed |= mark_lambda_list(lambda_list)
          end
          changed
        end

        # `(defstruct point x (y 0))` defines point and its slots.
        def mark_structure(forms)
          return false if forms.empty?

          changed = mark_binding(forms.first, :definition)
          forms[1..].each do |slot|
            changed |= mark_binding(slot, :definition) unless slot.type == "literal"
          end
          changed
        end

        # `(defclass shape (parent) ((side :accessor side)))` defines shape,
        # its slots and their accessors.
        def mark_class(forms)
          return false if forms.empty?

          changed = mark_binding(forms.first, :definition)
          slots = forms[2]
          return changed unless slots&.type == "list_lit"

          slots.named_children.each do |slot|
            next unless slot.type == "list_lit"

            changed |= mark_binding(slot, :definition)
            slot.named_children.each_cons(2) do |option, value|
              next unless option.type == "kwd_lit" && ACCESSOR_OPTIONS.include?(option.named_children.first&.text)

              changed |= mark_binding(value, :definition) if symbol?(value)
            end
          end
          changed
        end

        # `(handler-case form (error (e) ...))` binds e.
        def mark_handlers(clauses)
          clauses.map do |clause|
            next false unless clause.type == "list_lit"

            variables = clause.named_children[1]
            variables&.type == "list_lit" && mark_binding(variables.named_children.first, :variable)
          end.any?
        end
      end
    end
  end
end
