# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the forms that Clojure's reader gives.
module Representer::Languages::Clojure::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets and the `#` of a set, because the node types already show them.
    # #{1 2}  ->  (set_lit 1 2)
    strip_tokens "(", ")", "[", "]", "{", "}", "#"

    # Label the first item of each list and vector as its head, so that the
    # import `(require {{...}})` matches `(require 'clojure.set)`, and
    # doesn't match `(list 1 require)`.
    lists_are :list_lit, :vec_lit

    # Write each number as its value. A ratio, a number in another base and a
    # number with a suffix keep their text, because the reader gives them
    # other types.
    #
    # 0x1F  ->  31
    # 017  ->  15
    # 0.90  ->  0.9
    # 1e3  ->  1000.0
    numbers_are integer: :num_lit,
                decimal: :num_lit,
                prefixes: { "0x" => 16, "0" => 8 }

    FORMS = { quoting_lit: "quote", derefing_lit: "deref", var_quoting_lit: "var" }.freeze

    CONSTRUCTOR = /\A(?<marker>->|map->)(?<name>\p{Alpha}.*)\z/
    NEW = /\A(?<name>[^.].*)\.\z/
    METHOD = /\A\.(?<name>[^-.].*)\z/

    def call
      tree.tap do
        drop_metadata!
        write_strings_as_their_values!
        write_symbols_as_leaves!
        write_quotes_derefs_and_vars_as_forms!
        write_anonymous_functions_as_fn_forms!
        forget_field_names!
      end
    end

    private
    # Drop metadata, because the reader attaches it to the form and doesn't
    # give it as code.
    # (defn ^:private f [^long x] x)  ->  (defn f [x] x)
    def drop_metadata!
      drop(tree, "(meta_lit)")
    end

    # Write each string as its contents. Keep its escapes as they are written,
    # so two different strings can never get the same value.
    # "a b"  ->  (literal "a b")
    def write_strings_as_their_values!
      transform(tree, "(str_lit) @string") { |match| literal(match.node.text[1...-1]) }
    end

    # Write each symbol as one leaf. Keep a namespace apart from its name, and
    # keep the name that a method call or a constructor is made from, so that
    # the name can be renamed.
    # str/join  ->  (qualified str join)
    # .area  ->  (method area)
    # ->Point  ->  (constructor -> Point)
    # Point.  ->  (constructor new Point)
    def write_symbols_as_leaves!
      transform(tree, "(sym_lit) @symbol") { |match| symbol(match.node) }
    end

    def symbol(node)
      name = node[:name].text
      return build(:qualified, leaf(:namespace, node[:namespace].text), leaf(:sym, name)) if node[:namespace]

      if (parts = name.match(CONSTRUCTOR)) then build(:constructor, token(parts[:marker]), leaf(:sym, parts[:name]))
      elsif (parts = name.match(NEW)) then build(:constructor, token("new"), leaf(:sym, parts[:name]))
      elsif (parts = name.match(METHOD)) then build(:method, leaf(:sym, parts[:name]))
      else leaf(:sym, name)
      end
    end

    # Write a quote, a deref and a var as the forms that the reader gives.
    # 'x  ->  (quote x)
    # @x  ->  (deref x)
    # #'x  ->  (var x)
    def write_quotes_derefs_and_vars_as_forms!
      FORMS.each do |type, head|
        transform(tree, "(#{type}) @form") { |match| build(:list_lit, leaf(:sym, head), *match.node.named_children) }
      end
    end

    # Write each anonymous function as the `fn*` form that the reader gives,
    # with its parameters numbered.
    # #(+ % %2)  ->  (fn* ([%1 %2] (+ %1 %2)))
    # #(apply f %&)  ->  (fn* ([& %&] (apply f %&)))
    def write_anonymous_functions_as_fn_forms!
      transform(tree, "(anon_fn_lit) @function") { |match| fn_form(match.node) }
    end

    def fn_form(function)
      uses = []
      function.each_descendant { |node| uses << node if node.type == "sym" && node.text.match?(/\A%(\d+|&)?\z/) }
      uses.each { |use| use.text = "%1" if use.text == "%" }
      params = (1..uses.map { |use| use.text[/\d+/].to_i }.max.to_i).map { |index| leaf(:sym, "%#{index}") }
      params += [leaf(:sym, "&"), leaf(:sym, "%&")] if uses.any? { |use| use.text == "%&" }
      arity = build(:list_lit, build(:vec_lit, *params), build(:list_lit, *function.named_children))
      build(:list_lit, leaf(:sym, "fn*"), arity)
    end

    # Forget the grammar's field names, because every item of a form is a
    # value. The forms built by the later stages have none either, so code
    # patterns match both.
    def forget_field_names!
      tree.each_descendant { |node| node.field = nil }
    end
  end
end
