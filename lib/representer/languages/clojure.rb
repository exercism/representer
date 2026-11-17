module Representer
  module Languages
    # The old clojure-representer ran `macroexpand-all` on the student's code
    # (which executes macros) and then replaced every symbol that wasn't in
    # clojure.core or the tests. This class reads the code with tree-sitter
    # and never runs it. It rewrites the core macros that students use into
    # the forms that `macroexpand-all` gives, using the same expansions, so
    # `(when a b)` and `(if a (do b))` are the same.
    #
    # Macros that expand to generated names or runtime code (`and`, `or`,
    # `for`, `doseq`, `if-let`, `when-let`, `case`, `condp`, `ns`, and
    # destructuring) stay as written.
    class Clojure < Language
      tracks "clojure"
      version 2
      grammar "clojure"
      extensions ".clj", ".cljc", ".cljs"

      # A regular expression is one node with only its `#` as a child, so it
      # is kept as a leaf with its whole text.
      text_nodes :regex_lit

      # The grammar has no node for a name that the student defines, so the
      # rewrites below give those names the `local` type (parameters and
      # bindings) or the `definition` type (functions, vars, protocols, records),
      # and the rename rules can tell them from every other symbol.
      names :sym, :local, :definition

      # clojure.core names and special forms are never renamed, even if the
      # student binds a local with the same name (such as `name` or `mod`).
      CORE_NAMES = File.readlines(File.join(__dir__, "library_names", "clojure.txt"), chomp: true).
        reject { |line| line.empty? || line.start_with?("#") }.freeze

      # Forms whose first argument is a vector of bindings.
      BINDING_FORMS = %w[let loop with-open with-local-vars if-let when-let if-some when-some when-first for doseq dotimes].freeze
      # Forms that define a var, protocol or type with the name that follows.
      DEFINING_FORMS = %w[def defonce defmulti defprotocol definterface defrecord deftype defstruct].freeze
      # Forms that hold method implementations: `(method [this x] ...)`.
      IMPLEMENTING_FORMS = %w[reify extend-type extend-protocol proxy extend deftype defrecord defprotocol definterface].freeze

      ### Drop ###

      # Comments, `#_` forms and metadata (`^:private`, `^String`), none of
      # which `macroexpand-all` printed.
      drop "[(comment) (dis_expr) (meta_lit)]"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", "#", "'", "@", "#'"

      ### Rewrite ###

      # A symbol is one leaf with its whole text, such as `str/join`.
      rewrite("(sym_lit) @symbol") { |match| Clojure.symbol_node(match.node) }

      # A keyword is one leaf: `:a` and `::a` are different keywords.
      rewrite "(kwd_lit) @keyword" do |match|
        leaf(:kwd, match.node.children.map(&:text).join)
      end

      # 'x is (quote x), @x is (deref x) and #'x is (var x).
      rewrite "(quoting_lit) @form" do |match|
        Clojure.call_form("quote", match.node)
      end
      rewrite "(derefing_lit) @form" do |match|
        Clojure.call_form("deref", match.node)
      end
      rewrite "(var_quoting_lit) @form" do |match|
        Clojure.call_form("var", match.node)
      end

      # `#(foo % %2)` is `(fn [%1 %2] (foo %1 %2))`.
      rewrite("(anon_fn_lit) @function") { |match| Clojure.anonymous_function(match.node) }

      # `(comment ...)` expands to nil, so top-level REPL code goes away.
      rewrite("(source) @source") do |match|
        before = match.node.children.size
        match.node.children.reject! { |child| child.type == "nil_lit" }
        match.node.children.size == before ? nil : match.node
      end

      # The core macros, and the forms that define names.
      rewrite("(list_lit) @list") { |match| Clojure.expand(match.node) }

      ### Rename and keep ###

      rename "(local) @name"
      rename_member "(definition) @name"

      # A name after a namespace (`str/join`), a method call (`.area`) or a
      # constructor (`->Point`) is renamed only if the solution defines a name
      # like it.
      member "(qualified (sym) @name)"
      member "(method (sym) @name)"
      member "(constructor (sym) @name)"
      keep(*CORE_NAMES)

      class << self
        # `(quote x)` for a quoting marker with one form.
        def call_form(head, node)
          build(:list_lit, leaf(:sym, head), *node.named_children)
        end

        def head(node)
          return nil unless node.type == "list_lit"

          first = node.children.first
          first.text if first&.type == "sym"
        end

        # A symbol is a leaf. A symbol with a namespace has the namespace and
        # the name apart (`str/join`), so a name that the tests use as
        # `ns/name` is kept in the solution. Method calls (`.area`) and
        # constructors (`->Point`, `map->Point`, `Point.`) wrap the name they
        # are made from.
        def symbol_node(node)
          parts = node.children.reject { |child| child.type == "meta_lit" }
          name = parts.find { |part| part.type == "sym_name" }.text
          namespace = parts.find { |part| part.type == "sym_ns" }
          return build(:qualified, leaf(:namespace, namespace.text), leaf(:sym, name)) if namespace

          case name
          when /\A(->|map->)([[:alpha:]].*)\z/ then build(:constructor, token(::Regexp.last_match(1)),
            leaf(:sym, ::Regexp.last_match(2)))
          when /\A(?!\.)(.+)\.\z/ then build(:constructor, token("new"), leaf(:sym, ::Regexp.last_match(1)))
          when /\A\.(?![-.])(.+)\z/ then build(:method, leaf(:sym, ::Regexp.last_match(1)))
          else leaf(:sym, name)
          end
        end

        def nil_form = leaf(:nil_lit, "nil")
        def symbol(text) = leaf(:sym, text)
        def sym?(node) = node&.type == "sym"

        # Rewrites a list that is one of the forms below. Returns nil if the
        # list is something else, or if it needs no change.
        def expand(node)
          head = head(node)
          return nil unless head

          args = node.children.drop(1)
          case head
          when "->" then thread(args, :first)
          when "->>" then thread(args, :last)
          when "as->" then as_thread(args)
          when "cond->" then conditional_thread(args, "->")
          when "cond->>" then conditional_thread(args, "->>")
          when "some->" then nil_safe_thread(args, "->")
          when "some->>" then nil_safe_thread(args, "->>")
          when "when" then when_form(args)
          when "when-not" then when_not_form(args)
          when "if-not" then if_not_form(args)
          when "cond" then cond_form(args)
          when "comment" then nil_form
          when "defn", "defn-" then define_function(args, "def")
          when "defmacro" then define_function(args, "defmacro")
          when "fn" then function(args)
          when "fn*" then expanded_function(args)
          when "declare" then retype_all(args, :definition).positive? ? node : nil
          when "defmethod" then bind_first_vector(args) ? node : nil
          when "catch" then args[1] && retype(args[1], :local).positive? ? node : nil
          when "letfn" then letfn(args) ? node : nil
          else
            changed = 0
            changed += bind_bindings(args) if BINDING_FORMS.include?(head)
            changed += define_name(args) if DEFINING_FORMS.include?(head)
            changed += bind_implementations(head, args) if IMPLEMENTING_FORMS.include?(head)
            changed.zero? ? nil : node
          end
        end

        ### Threading macros ###

        # (-> x f (g a)) is (g (f x) a), and (->> x f (g a)) is (g a (f x)).
        def thread(args, position)
          value, *steps = args
          return nil unless value

          steps.reduce(value) do |acc, step|
            if step.type == "list_lit" && !step.children.empty?
              callee, *rest = step.children
              build(:list_lit, callee, *(position == :first ? [acc, *rest] : [*rest, acc]))
            else
              build(:list_lit, step, acc)
            end
          end
        end

        # (as-> x y (f y)) is (let [y x y (f y)] y).
        def as_thread(args)
          value, name, *forms = args
          return nil unless value && sym?(name)

          bindings = [copy(name), value] + forms.flat_map { |form| [copy(name), form] }
          build(:list_lit, symbol("let"), build(:vec_lit, *bindings), copy(name))
        end

        # (cond-> x t f) is (let [g x g (if t (-> g f) g)] g).
        def conditional_thread(args, arrow)
          value, *clauses = args
          return nil unless value && clauses.size.even?

          bindings = clauses.each_slice(2).flat_map do |test, step|
            threaded = build(:list_lit, symbol(arrow), generated, step)
            [generated, build(:list_lit, symbol("if"), test, threaded, generated)]
          end
          build(:list_lit, symbol("let"), build(:vec_lit, generated, value, *bindings), generated)
        end

        # (some-> x f) is (let [g x g (if (nil? g) nil (-> g f))] g).
        def nil_safe_thread(args, arrow)
          value, *steps = args
          return nil unless value

          bindings = steps.flat_map do |step|
            test = build(:list_lit, symbol("nil?"), generated)
            [generated, build(:list_lit, symbol("if"), test, nil_form, build(:list_lit, symbol(arrow), generated, step))]
          end
          build(:list_lit, symbol("let"), build(:vec_lit, generated, value, *bindings), generated)
        end

        # The name that a macro makes up, which no student can write, so it is
        # never renamed.
        def generated = leaf(:gensym, "g")

        ### Conditionals ###

        # (when t a b) is (if t (do a b)).
        def when_form(args)
          test, *body = args
          return nil unless test

          build(:list_lit, symbol("if"), test, build(:list_lit, symbol("do"), *body))
        end

        # (when-not t a) is (if t nil (do a)).
        def when_not_form(args)
          test, *body = args
          return nil unless test

          build(:list_lit, symbol("if"), test, nil_form, build(:list_lit, symbol("do"), *body))
        end

        # (if-not t a b) is (if (not t) a b), and a missing else is nil.
        def if_not_form(args)
          test, consequence, alternative = args
          return nil unless test && consequence && args.size <= 3

          build(:list_lit, symbol("if"), build(:list_lit, symbol("not"), test), consequence, alternative || nil_form)
        end

        # (cond a b c d) is (if a b (if c d nil)).
        def cond_form(args)
          return nil_form if args.empty?
          return nil if args.size.odd?

          test, result, *rest = args
          build(:list_lit, symbol("if"), test, result, build(:list_lit, symbol("cond"), *rest))
        end

        ### Functions ###

        # (defn f "doc" {:a 1} [x] ...) is (def f (fn* ([x] ...))). The
        # docstring and the attribute map are metadata, which expansion
        # leaves out.
        def define_function(args, head)
          name, *rest = args
          return nil unless sym?(name)

          rest.shift if rest.first&.type == "str_lit"
          rest.shift if rest.first&.type == "map_lit"
          arities = arities_of(rest)
          return nil unless arities

          name.type = "definition"
          build(:list_lit, symbol(head), name, build(:list_lit, symbol("fn*"), *arities))
        end

        # (fn name? [x] ...) is (fn* name? ([x] ...)).
        def function(args)
          name = args.first if sym?(args.first)
          arities = arities_of(name ? args.drop(1) : args)
          return nil unless arities

          retype(name, :local) if name
          build(:list_lit, symbol("fn*"), *[name, *arities].compact)
        end

        # Code pasted from `macroexpand-all` has `(fn* [x] ...)`, which is
        # `(fn* ([x] ...))`. Returns nil if the form is already in that shape
        # and its parameters are bound.
        def expanded_function(args)
          name = args.first if sym?(args.first)
          rest = name ? args.drop(1) : args
          if rest.first&.type == "vec_lit"
            retype(name, :local) if name
            return function(args)
          end

          changed = rest.sum do |arity|
            arity.type == "list_lit" && arity.children.first&.type == "vec_lit" ? bind(arity.children.first) : 0
          end
          changed += retype(name, :local) if name
          changed.zero? ? nil : build(:list_lit, symbol("fn*"), *args)
        end

        # The arities written as `[x] body...` or as `([x] body...) ...`,
        # always as a list of `([x] body...)` with each parameter bound.
        def arities_of(forms)
          if forms.first&.type == "vec_lit"
            arities =
              [build(:list_lit, *forms)]
          else
            arities =
              forms.select { |form| form.type == "list_lit" && form.children.first&.type == "vec_lit" }
          end
          return nil if arities.empty?

          arities.each { |arity| bind(arity.children.first) }
        end

        # `#(f % %2 %&)` is `(fn* ([%1 %2 & %&] (f %1 %2 %&)))`.
        def anonymous_function(node)
          uses = []
          node.each_descendant { |child| uses << child if child.type == "sym" && child.text.match?(/\A%(\d+|&)?\z/) }
          highest = 0
          rest = false
          uses.each do |use|
            highest = [highest, use.text[/\d+/].to_i].max
            highest = [highest, 1].max if use.text == "%"
            rest = true if use.text == "%&"
            use.text = "%1" if use.text == "%"
          end

          params = (1..highest).map { |index| leaf(:local, "%#{index}") }
          params += [leaf(:sym, "&"), leaf(:local, "%&")] if rest
          body = build(:list_lit, *node.named_children)
          build(:list_lit, symbol("fn*"), build(:list_lit, build(:vec_lit, *params), body))
        end

        ### Names ###

        # Gives every symbol in a binding pattern the `local` type, and
        # returns how many it changed. A pattern is a symbol, a vector of
        # patterns, or a map such as {:keys [a b] :as all, c :c}.
        def bind(pattern)
          case pattern.type
          when "sym" then pattern.text.include?("/") ? 0 : retype(pattern, :local)
          when "vec_lit" then pattern.children.sum { |child| bind(child) }
          when "map_lit" then pattern.children.each_slice(2).sum { |key, value| bind_map_entry(key, value) }
          else 0
          end
        end

        def bind_map_entry(key, value)
          return bind(key) unless key.type == "kwd"

          case key.text
          when ":keys", ":strs", ":syms", ":as" then value ? bind(value) : 0
          when ":or" then value&.type == "map_lit" ? value.children.each_slice(2).sum { |name, _| bind(name) } : 0
          else 0
          end
        end

        # The bindings of let, loop, for and similar forms, as pairs of a
        # pattern and a value. `:let [...]` inside for and doseq binds too.
        def bind_bindings(args)
          vector = args.first
          return 0 unless vector&.type == "vec_lit"

          vector.children.each_slice(2).sum do |pattern, value|
            if pattern.type == "kwd"
              pattern.text == ":let" && value&.type == "vec_lit" ? bind_bindings([value]) : 0
            else
              bind(pattern)
            end
          end
        end

        # (defmethod area :square [{:keys [side]}] ...)
        def bind_first_vector(args)
          vector = args.find { |arg| arg.type == "vec_lit" }
          vector ? bind(vector).positive? : false
        end

        # (letfn [(f [x] ...) (g [y] ...)] ...)
        def letfn(args)
          vector = args.first
          return false unless vector&.type == "vec_lit"

          vector.children.sum do |function|
            next 0 unless function.type == "list_lit" && sym?(function.children.first)

            retype(function.children.first, :local) + function.children.drop(1).sum { |part| part.type == "vec_lit" ? bind(part) : 0 }
          end.positive?
        end

        # The name after def, defonce, defprotocol, defrecord and the like.
        def define_name(args)
          name = args.first
          sym?(name) && !name.text.include?("/") ? retype(name, :definition) : 0
        end

        # Record fields, and the method names and parameters of protocols,
        # records and reify.
        def bind_implementations(head, args)
          changed = 0
          changed += bind(args[1]) if %w[defrecord deftype].include?(head) && args[1]&.type == "vec_lit"
          args.each do |form|
            next unless form.type == "list_lit" && sym?(form.children.first) && form.children[1]&.type == "vec_lit"

            changed += retype(form.children.first, :definition) if %w[defprotocol definterface].include?(head)
            changed += bind(form.children[1])
          end
          changed
        end

        def retype_all(nodes, type) = nodes.sum { |node| retype(node, type) }

        # Gives a symbol another type, and returns 1 if it changed.
        def retype(node, type)
          return 0 unless node.type == "sym"

          node.type = type.to_s
          1
        end
      end
    end
  end
end
