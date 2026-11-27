# What this class does to a Clojure solution's code to make its representation:
#
# - Drops comments, `#_` forms and metadata.
# - Drops brackets and quote marks that the tree already shows.
# - Writes `'x`, `@x` and `#'x` as `(quote x)`, `(deref x)` and `(var x)`,
#   and `#(f %)` as an `fn` form.
# - Expands the core macros (`->`, `->>`, `and`, `or`, `when`, `cond`,
#   `if-let`, `for` and others) into the forms that `macroexpand-all` gives,
#   with generated names numbered from `G__1`.
# - Expands a macro that the solution defines with one syntax-quoted
#   template wherever it is used.
# - Drops `(comment ...)` forms at the top level.
# - Writes `ns` in one form: without its docstring, attribute map and
#   `:require`, `:use` and `:import` clauses, and with its other clauses
#   merged and sorted.
# - Drops `require`, `use` and `import` forms, which only make names
#   available.
# - Writes numbers as their values (`0x1F` is `31`, `0.90` is `0.9`), and
#   keeps the text of ratios, radix numbers and numbers with a suffix.
# - Sorts the items of a set, and the entries of a map, when they are all
#   literal values.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests and the members of the exercise's stub.
# - Keeps every clojure.core name, even where the solution binds a local
#   with the same name.
# - Renames a name after a namespace, a method call or a constructor only if
#   the solution defines it.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # The old clojure-representer ran `macroexpand-all` on the student's code
    # (which executes macros) and then replaced every symbol that wasn't in
    # clojure.core or the tests. This class reads the code with tree-sitter
    # and never runs it. It rewrites the core macros that students use into
    # the forms that `macroexpand-all` gives, using the same expansions, so
    # `(when a b)` and `(if a (do b))` are the same.
    #
    # `and`, `or`, `if-let`, `when-let` and destructuring expand to code that
    # uses generated names. Real expansion numbers those names globally, so
    # this class numbers them from `G__1` inside each expansion instead, which
    # gives the same name to the same code every time. `for` becomes nested
    # `map`, `mapcat`, `filter` and `take-while` calls, and `ns` becomes one
    # canonical `ns` form with its clauses merged and sorted. A macro that the
    # student defines with `defmacro`, with one syntax-quoted template as its
    # body, is expanded at each use by substituting the arguments into the
    # template. Nothing in the student's code is ever run.
    #
    # `doseq`, `case`, `condp` and `loop` destructuring stay as written.
    class Clojure < Language
      tracks "clojure"
      version 8
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

      IMPORT_CLAUSES = %w[:require :use :import].freeze

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
      rewrite("(source) @source") { |match| Clojure.expand_source(match.node) }

      # The core macros, and the forms that define names.
      rewrite("(list_lit) @list") { |match| Clojure.expand(match.node) }

      # Numbers are their values: `0x1F` is `31`, and `0.90` is `0.9`. A
      # number with a suffix (`1N`, `1M`), a ratio or a radix keeps its text.
      numbers :num_lit do |text|
        value = Engine::Numbers.integer(text, separator: "", prefixes: { "0x" => 16 })
        next value.to_s if value

        value = text.match?(/[.eE]/) && Engine::Numbers.decimal(text, separator: "")
        value && Engine::Numbers.write_decimal(value)
      end

      # The order of a set's items, or of a map's entries, doesn't change it.
      # Only sets and maps of literal values (strings, characters, numbers
      # and keywords) are sorted, because the order of other items can
      # depend on the names that the solution chose.
      rewrite "(set_lit) @set" do |match|
        items = match.node.children
        next nil unless items.all? { |item| Clojure.literal?(item) }

        sorted = items.sort_by { |item| [item.type, item.text] }
        sorted == items ? nil : build(:set_lit, *sorted)
      end
      rewrite "(map_lit) @map" do |match|
        entries = match.node.children.each_slice(2).to_a
        next nil unless entries.all? { |entry| entry.size == 2 && entry.all? { |item| Clojure.literal?(item) } }

        sorted = entries.sort_by { |key, value| [key.type, key.text, value.type, value.text] }
        sorted == entries ? nil : build(:map_lit, *sorted.flatten)
      end

      ### Rename and keep ###

      rename "(local) @name"
      rename_member "(definition) @name"

      # A name after a namespace (`str/join`), a method call (`.area`) or a
      # constructor (`->Point`) is renamed only if the solution defines a name
      # like it.
      member "(qualified (sym) @name)"
      member "(method (sym) @name)"
      member "(constructor (sym) @name)"

      # `&` marks the rest of a binding vector, and `_` marks an unused binding.
      keep "&", "_"

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

        LITERALS = %w[str_lit char_lit num_lit kwd literal].freeze

        def literal?(node) = node.leaf? && LITERALS.include?(node.type)

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
          when "and" then and_form(args)
          when "or" then or_form(args)
          when "if-let" then if_let_form(args)
          when "when-let" then when_let_form(args)
          when "for" then for_form(args)
          when "ns" then ns_form(node, args)
          when "require", "use", "import" then import_form(head, args)
          when "let" then destructure_let(args) || bind_names(node, head, args)
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
          else bind_names(node, head, args)
          end
        end

        # Gives the names that a form defines their types. Returns nil if
        # there are none to change.
        def bind_names(node, head, args)
          changed = 0
          changed += bind_bindings(args) if BINDING_FORMS.include?(head)
          changed += define_name(args) if DEFINING_FORMS.include?(head)
          changed += bind_implementations(head, args) if IMPLEMENTING_FORMS.include?(head)
          changed.zero? ? nil : node
        end

        def form(head, *args) = build(:list_lit, symbol(head), *args)
        def bool(value) = leaf(:bool_lit, value.to_s)

        # The numbered names that expansion makes up (`G__1`, `G__2`...). Each
        # expansion has its own counter, so the same code always gets the same
        # names. Call the result for a new name, and `copy` it to use it again.
        def gensyms
          count = 0
          -> { leaf(:gensym, "G__#{count += 1}") }
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

        # (and) is true, (and x) is x, and (and x y) is
        # (let [G__1 x] (if G__1 (and y) G__1)).
        def and_form(args)
          return bool(true) if args.empty?
          return args.first if args.size == 1

          first, *rest = args
          temp = gensyms.()
          form("let", build(:vec_lit, temp, first), form("if", copy(temp), form("and", *rest), copy(temp)))
        end

        # (or) is nil, (or x) is x, and (or x y) is
        # (let [G__1 x] (if G__1 G__1 (or y))).
        def or_form(args)
          return nil_form if args.empty?
          return args.first if args.size == 1

          first, *rest = args
          temp = gensyms.()
          form("let", build(:vec_lit, temp, first), form("if", copy(temp), copy(temp), form("or", *rest)))
        end

        # (if-let [x t] a b) is (let [G__1 t] (if G__1 (let [x G__1] a) b)).
        def if_let_form(args)
          binding, consequence, alternative = args
          return nil unless binding&.type == "vec_lit" && binding.children.size == 2 && consequence && args.size <= 3

          pattern, test = binding.children
          temp = gensyms.()
          inner = form("let", build(:vec_lit, pattern, copy(temp)), consequence)
          form("let", build(:vec_lit, temp, test), form("if", copy(temp), inner, alternative || nil_form))
        end

        # (when-let [x t] a) is (let [G__1 t] (when G__1 (let [x G__1] a))).
        def when_let_form(args)
          binding, *body = args
          return nil unless binding&.type == "vec_lit" && binding.children.size == 2

          pattern, test = binding.children
          temp = gensyms.()
          inner = form("let", build(:vec_lit, pattern, copy(temp)), *body)
          form("let", build(:vec_lit, temp, test), form("when", copy(temp), inner))
        end

        ### For ###

        # `for` becomes calls that give the same result: each generator is a
        # `map` (the last one) or a `mapcat` of a function, and `:when` and
        # `:while` become a `filter` and a `take-while` of the generator's
        # collection. A generator with a `:let` keeps its modifiers inside
        # the function instead, so `:let` can be used by the modifiers after it.
        def for_form(args)
          vector, *body = args
          return nil unless vector&.type == "vec_lit" && vector.children.size.even? && body.size == 1

          generators = []
          vector.children.each_slice(2) do |key, value|
            if key.type == "kwd" && %w[:when :while :let].include?(key.text)
              return nil if generators.empty?

              generators.last[2] << [key, value]
            else
              generators << [key, value, []]
            end
          end
          return nil if generators.empty?

          generate(generators, body.first)
        end

        def generate(generators, body)
          (pattern, collection, modifiers), *rest = generators
          last = rest.empty?
          lets = modifiers.any? { |key, _| key.text == ":let" }

          if lets
            return nil if modifiers.any? { |key, _| key.text == ":while" }

            inner = last ? build(:vec_lit, body) : generate(rest, body)
            return nil unless inner

            inner = modifiers.reverse.reduce(inner) do |acc, (key, value)|
              key.text == ":let" ? form("let", value, acc) : form("when", value, acc)
            end
            return form("mapcat", function_of([pattern], inner), collection)
          end

          inner = last ? body : generate(rest, body)
          return nil unless inner

          collection = modifiers.reduce(collection) do |acc, (key, value)|
            form(key.text == ":when" ? "filter" : "take-while", function_of([copy(pattern)], value), acc)
          end
          form(last ? "map" : "mapcat", function_of([pattern], inner), collection)
        end

        def function_of(params, body) = form("fn", build(:vec_lit, *params), body)

        ### Namespaces ###

        # `ns` becomes one canonical `ns`: the docstring and attribute map
        # are dropped, and so are the `:require`, `:use` and `:import`
        # clauses, which only make names available. Each other kind of clause
        # (such as `:refer-clojure` or `:gen-class`) is merged into one, and
        # the clauses are sorted.
        def ns_form(node, args)
          name, *clauses = args
          return nil unless sym?(name)

          clauses.shift if clauses.first&.type == "str_lit"
          clauses.shift if clauses.first&.type == "map_lit"
          groups = Hash.new { |hash, key| hash[key] = [] }
          clauses.each do |clause|
            key = clause.children.first if %w[list_lit vec_lit].include?(clause.type)
            return nil unless key&.type == "kwd"

            groups[key.text].concat(clause.children.drop(1)) unless IMPORT_CLAUSES.include?(key.text)
          end

          result = form("ns", name, *groups.keys.sort.map { |key| build(:list_lit, leaf(:kwd, key), *groups[key]) })
          result.children[0] = symbol("ns")
          result.inspect == node.inspect ? nil : result
        end

        # `(require '[clojure.string :as str])`, `(use 'clojure.set)` and
        # `(import 'java.util.Date)` only make names available, so they
        # become nil, which goes away at the top level.
        def import_form(kind, args)
          return nil if args.empty?

          libraries = args.all? { |arg| arg.type == "kwd" || head(arg) == "quote" || (kind == "import" && sym?(arg)) }
          libraries ? nil_form : nil
        end

        ### Destructuring ###

        def destructuring?(pattern) = %w[vec_lit map_lit].include?(pattern.type)

        # A `let` with a vector or map pattern becomes a `let` of plain names:
        # `[a b] v` is `G__1 v a (nth G__1 0 nil) b (nth G__1 1 nil)`. Returns
        # nil if there is no pattern, or one that isn't understood.
        def destructure_let(args)
          vector, *body = args
          return nil unless vector&.type == "vec_lit" && vector.children.size.even?
          return nil unless vector.children.each_slice(2).any? { |pattern, _| destructuring?(pattern) }

          gen = gensyms
          bindings = vector.children.each_slice(2).flat_map do |pattern, value|
            expand_pattern(pattern, value, gen) || (return nil)
          end
          form("let", build(:vec_lit, *bindings), *body)
        end

        # The names and values that a pattern binds, as a flat list. Returns
        # nil for a pattern that isn't understood.
        def expand_pattern(pattern, value, gen)
          case pattern.type
          when "sym", "local", "gensym" then [pattern, value]
          when "vec_lit" then expand_vector(pattern, value, gen)
          when "map_lit" then expand_map(pattern, value, gen)
          end
        end

        def expand_vector(pattern, value, gen)
          temp = gen.()
          bindings = [temp, value]
          items = pattern.children
          index = 0
          position = 0
          while position < items.size
            item = items[position]
            if sym?(item) && item.text == "&"
              rest = items[position + 1]
              return nil unless rest && position + 2 == items.size || rest && items[position + 2]&.type == "kwd"

              sub = expand_pattern(rest, form("nthnext", copy(temp), leaf(:num_lit, index.to_s)), gen)
              return nil unless sub && rest.type != "map_lit"

              bindings.concat(sub)
              position += 2
            elsif item.type == "kwd" && item.text == ":as"
              name = items[position + 1]
              return nil unless sym?(name)

              bindings.push(name, copy(temp))
              position += 2
            else
              sub = expand_pattern(item, form("nth", copy(temp), leaf(:num_lit, index.to_s), nil_form), gen)
              return nil unless sub

              bindings.concat(sub)
              index += 1
              position += 1
            end
          end
          bindings
        end

        def expand_map(pattern, value, gen)
          entries = pattern.children.each_slice(2).to_a
          return nil if entries.any? { |_, entry_value| entry_value.nil? }

          defaults = {}
          entries.each do |key, entry_value|
            next unless key.type == "kwd" && key.text == ":or"
            return nil unless entry_value.type == "map_lit"

            entry_value.children.each_slice(2) { |name, default| defaults[name.text] = default }
          end

          temp = gen.()
          bindings = [temp, value]
          entries.each do |key, entry_value|
            if key.type == "kwd"
              sub = expand_map_option(key.text, entry_value, temp, defaults)
            else
              default = defaults[key.text] if sym?(key)
              sub = expand_pattern(key, get_call(temp, entry_value, default), gen)
            end
            return nil unless sub

            bindings.concat(sub)
          end
          bindings
        end

        def get_call(temp, key, default) = form("get", copy(temp), key, *[default].compact)

        # `:as m`, `:or {...}` and `:keys [a b]` (also `:strs`, `:syms`, and
        # a namespace before the slash).
        def expand_map_option(option, value, temp, defaults)
          return [value, copy(temp)] if option == ":as" && sym?(value)
          return [] if option == ":or"

          match = option.match(%r{\A:(?:(.+)/)?(keys|strs|syms)\z})
          return nil unless match && value.type == "vec_lit" && value.children.all? { |name| sym?(name) && !name.text.include?("/") }

          namespace = match[1] ? "#{match[1]}/" : ""
          value.children.flat_map do |name|
            case match[2]
            when "keys" then key =
                               leaf(:kwd, ":#{namespace}#{name.text}")
            when "strs" then key =
                               leaf(:str_lit, %("#{name.text}"))
            else key =
                   form("quote", leaf(:sym, "#{namespace}#{name.text}"))
            end
            [name, get_call(temp, key, defaults[name.text])]
          end
        end

        # Replaces each parameter that is a pattern with a made-up name, and
        # binds the pattern to it in a `let` around the body.
        def destructure_params(arity)
          params, *body = arity.children
          return unless params.children.any? { |param| destructuring?(param) }

          gen = gensyms
          bindings = []
          new_params = []
          params.children.each do |param|
            unless destructuring?(param)
              new_params << param
              next
            end

            temp = gen.()
            sub = expand_pattern(param, copy(temp), gen)
            return nil unless sub

            bindings.concat(sub)
            new_params << temp
          end
          params.children.replace(new_params)
          arity.children.replace([params, form("let", build(:vec_lit, *bindings), *body)])
        end

        ### Student macros ###

        # Removes the `nil` forms that `comment` leaves, then expands every
        # use of the macros that the file defines.
        def expand_source(source)
          before = source.children.size
          source.children.reject! { |child| child.type == "nil_lit" }
          dropped = source.children.size != before

          macros = student_macros(source)
          return dropped ? source : nil if macros.empty?

          expanded = expand_uses(source, macros)
          if expanded.positive?
            build(:source, *source.children)
          else
            (dropped ? source : nil)
          end
        end

        Macro = Struct.new(:required, :rest, :template)

        # The macros that `defmacro` defines with simple parameters and one
        # syntax-quoted template as the body, by name. A macro whose template
        # uses a student macro is left alone, so expansion always ends.
        def student_macros(source)
          candidates = {}
          source.children.each do |form|
            next unless head(form) == "defmacro"

            name, function = form.children[1..2]
            next unless name&.type == "definition" && head(function) == "fn*" && function.children.size == 2

            arity = function.children[1]
            next unless arity.type == "list_lit" && arity.children.size == 2

            params, template = arity.children
            next unless params.type == "vec_lit" && template.type == "syn_quoting_lit"

            required, rest = macro_params(params)
            candidates[name.text] = Macro.new(required, rest, template.children.last) if required
          end

          names = candidates.keys
          candidates.reject do |_, macro|
            used = []
            macro.template.each_descendant { |node| used << node.text if node.text }
            used.intersect?(names)
          end
        end

        # The names before `&`, and the name after it (or nil).
        def macro_params(params)
          names = params.children
          rest_at = names.index { |param| param.text == "&" }
          required = rest_at ? names[0...rest_at] : names
          rest = rest_at ? names[rest_at + 1] : nil
          return nil unless (required + [rest].compact).all? { |param| param.type == "local" }
          return nil if rest_at && names.size != rest_at + 2

          [required.map(&:text), rest&.text]
        end

        # Replaces each use of a macro with its template, and returns how
        # many it replaced. Uses inside the new code wait for the next pass.
        def expand_uses(node, macros)
          count = 0
          node.children.each_with_index do |child, index|
            macro = macros[head(child)] if child.type == "list_lit"
            expansion = substitute_macro(macro, child.children.drop(1)) if macro
            if expansion
              expansion.field = child.field
              node.children[index] = expansion
              count += 1
            else
              count += expand_uses(child, macros)
            end
          end
          count
        end

        # The template with the arguments in place of the parameters, or nil
        # if the use doesn't fit the macro.
        def substitute_macro(macro, args)
          return nil if args.size < macro.required.size || (!macro.rest && args.size != macro.required.size)

          env = macro.required.zip(args).to_h
          rest = args.drop(macro.required.size)
          gen = gensyms
          auto = {}
          result = catch(:no_expansion) { substitute(macro.template, env, macro.rest, rest, gen, auto) }
          result.is_a?(Array) ? nil : result
        end

        # Returns a node, or an array of nodes for `~@rest`.
        def substitute(node, env, rest_name, rest, gen, auto)
          case node.type
          when "unquoting_lit"
            target = node.children.last
            throw :no_expansion unless %w[sym local].include?(target.type)
            return copy(env.fetch(target.text)) if env.key?(target.text)
            return form("list", *rest.map { |arg| copy(arg) }) if target.text == rest_name

            throw :no_expansion
          when "unquote_splicing_lit"
            target = node.children.last
            throw :no_expansion unless target.text == rest_name

            return rest.map { |arg| copy(arg) }
          when "syn_quoting_lit" then throw :no_expansion
          when "sym", "local"
            return node unless node.text.end_with?("#")

            return copy(auto[node.text] ||= gen.())
          end

          copy = node.dup
          copy.children = node.children.flat_map { |child| Array(substitute(child, env, rest_name, rest, gen, auto)) }
          copy
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

          arities.each do |arity|
            destructure_params(arity)
            bind(arity.children.first)
          end
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
