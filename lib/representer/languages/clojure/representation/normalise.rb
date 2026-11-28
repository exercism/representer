# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Clojure
# expands every macro before it runs the code, so this stage expands the core
# macros that solutions use, and the solution's own simple macros, into the
# forms that Clojure's `macroexpand-all` gives. It never runs a macro.
module Representer::Languages::Clojure::Representation
  class Normalise < Representer::Engine::Normalise
    # Drop the docstring and attribute map of `ns`, because they only add metadata.
    # (ns app "Counts things." {:author "me"})  ->  (ns app)
    rewrite '(ns {{name}} "{{_}}" {{...clauses}})',     as: "(ns {{name}} {{...clauses}})"
    rewrite "(ns {{name}} { {{...}} } {{...clauses}})", as: "(ns {{name}} {{...clauses}})"

    # Write each `comment` form as nil, which is what it gives.
    # (comment (f 1))  ->  nil
    rewrite "(comment {{...}})", as: "nil"

    DEFINITIONS = ["def", "defonce", "defmulti", "defmacro", "defprotocol", "definterface", "defrecord", "deftype",
                   "defstruct"].freeze

    BINDINGS = ["let", "loop", "with-open", "with-local-vars", "if-let", "when-let", "if-some", "when-some",
                "when-first", "for", "doseq", "dotimes"].freeze

    IMPLEMENTATIONS = ["reify", "extend-type", "extend-protocol", "proxy", "extend", "deftype", "defrecord",
                       "defprotocol", "definterface"].freeze

    MAP_OPTION = %r{\A:(?:(?<namespace>.+)/)?(?<kind>keys|strs|syms)\z}

    Macro = Struct.new(:parameters, :rest, :template)

    def call
      super.tap do |root|
        drop_nils_at_the_top_level!(root)
        expand_macros!(root)
        mark_the_names_each_form_defines!(root)
      end
    end

    private
    # Drop each nil at the top level of the file, because it does nothing. A
    # `comment` form at the top level leaves one.
    # (comment (f 1))  ->
    def drop_nils_at_the_top_level!(root)
      root.children.reject! { |form| form.type == "nil_lit" }
    end

    ### Expanding macros ###

    # Expand each macro the way `macroexpand-all` does: expand a form until it
    # is no longer a macro, then expand each form inside it. Leave
    # syntax-quoted code as it is, because it is a template that Clojure
    # expands only where the macro is used.
    def expand_macros!(root)
      @macros = student_macros(root)
      root.children.map! { |form| expanded(form) }
    end

    def expanded(form)
      while (expansion = expansion_of(form))
        form = expansion
      end
      form.children.map! { |child| expanded(child) } unless form.type == "syn_quoting_lit"
      form
    end

    # Return the code that the form expands to, or nil if it isn't a macro.
    def expansion_of(form)
      head, *args = form.children
      return unless form.type == "list_lit" && head&.type == "sym"

      macro = @macros[head.text]
      macro ? substituted_template(macro, args) : core_expansion(head.text, args)
    end

    def core_expansion(head, args)
      case head
      when "->" then thread(:first, *args)
      when "->>" then thread(:last, *args)
      when "as->" then as_thread(*args)
      when "cond->", "cond->>" then cond_thread(head.delete_prefix("cond"), *args)
      when "some->", "some->>" then some_thread(head.delete_prefix("some"), *args)
      when "when" then when_form(*args)
      when "when-not" then when_not(*args)
      when "if-not" then if_not(*args)
      when "cond" then cond(*args)
      when "and" then and_form(*args)
      when "or" then or_form(*args)
      when "if-let" then if_let(*args)
      when "when-let" then when_let(*args)
      when "for" then for_form(*args)
      when "let" then let_without_destructuring(*args)
      when "fn", "fn*" then fn_form(head, *args)
      when "defn", "defn-" then defn("def", *args)
      when "defmacro" then defn("defmacro", *args)
      end
    end

    ### Threading macros ###

    # Thread the value through each step, as its first or its last argument.
    # (-> x f (g a))  ->  (g (f x) a)
    # (->> x f (g a))  ->  (g a (f x))
    def thread(position, value, *steps)
      steps.reduce(value) do |threaded, step|
        callee, *rest = step.type == "list_lit" ? step.children : [step]
        list(callee, *(position == :first ? [threaded, *rest] : [*rest, threaded]))
      end
    end

    # (as-> x v (inc v) (* v 2))  ->  (let [v x v (inc v) v (* v 2)] v)
    def as_thread(value, name, *steps)
      form("let", vector(copy(name), value, *steps.flat_map { |step| [copy(name), step] }), copy(name))
    end

    # Thread the value through each step whose test holds, with `g` as a name
    # that no solution can write.
    # (cond-> x (pos? y) inc)  ->  (let [g x g (if (pos? y) (-> g inc) g)] g)
    def cond_thread(arrow, value, *clauses)
      bindings = clauses.each_slice(2).flat_map do |test, step|
        [generated, form("if", test, form(arrow, generated, step), generated)]
      end
      form("let", vector(generated, value, *bindings), generated)
    end

    # (some-> x f)  ->  (let [g x g (if (nil? g) nil (-> g f))] g)
    def some_thread(arrow, value, *steps)
      bindings = steps.flat_map do |step|
        [generated, form("if", form("nil?", generated), nil_form, form(arrow, generated, step))]
      end
      form("let", vector(generated, value, *bindings), generated)
    end

    ### Conditionals ###

    # (when t a b)  ->  (if t (do a b))
    def when_form(test, *body) = form("if", test, form("do", *body))

    # (when-not t a b)  ->  (if t nil (do a b))
    def when_not(test, *body) = form("if", test, nil_form, form("do", *body))

    # (if-not t a)  ->  (if (not t) a nil)
    def if_not(test, consequence, alternative = nil_form) = form("if", form("not", test), consequence, alternative)

    # (cond)  ->  nil
    # (cond a b c d)  ->  (if a b (cond c d))
    def cond(*clauses)
      return nil_form if clauses.empty?

      test, result, *rest = clauses
      form("if", test, result, form("cond", *rest))
    end

    # (and)  ->  true
    # (and x)  ->  x
    # (and x y)  ->  (let [G__1 x] (if G__1 (and y) G__1))
    def and_form(*values)
      return leaf(:bool_lit, "true") if values.empty?
      return values.first if values.one?

      first, *rest = values
      temp = gensyms.next
      form("let", vector(temp, first), form("if", copy(temp), form("and", *rest), copy(temp)))
    end

    # (or)  ->  nil
    # (or x)  ->  x
    # (or x y)  ->  (let [G__1 x] (if G__1 G__1 (or y)))
    def or_form(*values)
      return nil_form if values.empty?
      return values.first if values.one?

      first, *rest = values
      temp = gensyms.next
      form("let", vector(temp, first), form("if", copy(temp), copy(temp), form("or", *rest)))
    end

    # (if-let [x t] a b)  ->  (let [G__1 t] (if G__1 (let [x G__1] a) b))
    def if_let(binding, consequence, alternative = nil_form)
      pattern, test = binding.children
      temp = gensyms.next
      inner = form("let", vector(pattern, copy(temp)), consequence)
      form("let", vector(temp, test), form("if", copy(temp), inner, alternative))
    end

    # (when-let [x t] a b)  ->  (let [G__1 t] (when G__1 (let [x G__1] a b)))
    def when_let(binding, *body)
      pattern, test = binding.children
      temp = gensyms.next
      form("let", vector(temp, test), form("when", copy(temp), form("let", vector(pattern, copy(temp)), *body)))
    end

    ### For ###

    # Write `for` as the calls that give the same sequence. Each binding
    # becomes a `map` (the last one) or a `mapcat` of a function over its
    # collection, and each `:when` or `:while` becomes a `filter` or a
    # `take-while` of the collection. A binding with a `:let` keeps its
    # modifiers inside the function, so the modifiers after the `:let` can
    # use its names.
    # (for [i xs] (inc i))  ->  (map (fn [i] (inc i)) xs)
    # (for [i xs :when (odd? i)] i)  ->  (map (fn [i] i) (filter (fn [i] (odd? i)) xs))
    # (for [i xs j ys] [i j])  ->  (mapcat (fn [i] (map (fn [j] [i j]) ys)) xs)
    # (for [i xs :let [j (* i i)]] j)  ->  (mapcat (fn [i] (let [j (* i i)] [j])) xs)
    def for_form(bindings, body)
      generators = bindings.children.each_slice(2).slice_before { |key, _| key.type != "kwd_lit" }
      comprehension(generators.to_a, body)
    end

    # Return nil for a `:while` in a binding with a `:let`, which stays as it is written.
    def comprehension(generators, body)
      ((pattern, collection), *modifiers), *rest = generators
      inner = rest.empty? ? body : comprehension(rest, body)
      return unless inner

      if modifiers.any? { |key, _| key.text == ":let" }
        return if modifiers.any? { |key, _| key.text == ":while" }

        inner = modifiers.reverse.reduce(rest.empty? ? vector(inner) : inner) do |result, (key, value)|
          form(key.text == ":let" ? "let" : "when", value, result)
        end
        return form("mapcat", form("fn", vector(pattern), inner), collection)
      end

      collection = modifiers.reduce(collection) do |result, (key, value)|
        form(key.text == ":when" ? "filter" : "take-while", form("fn", vector(copy(pattern)), value), result)
      end
      form(rest.empty? ? "map" : "mapcat", form("fn", vector(pattern), inner), collection)
    end

    ### Destructuring ###

    # Write a `let` that destructures as a `let` of plain names, with a
    # generated name for each value that it takes apart. Return nil for a
    # `let` of plain names, or for a pattern this stage can't take apart,
    # which stays as it is written.
    # (let [[a b] v] a)  ->  (let [G__1 v a (nth G__1 0 nil) b (nth G__1 1 nil)] a)
    def let_without_destructuring(bindings, *body)
      pairs = bindings.children.each_slice(2).to_a
      return unless pairs.any? { |pattern, _| destructuring?(pattern) }

      names = gensyms
      plain = pairs.map { |pattern, value| destructured(pattern, value, names) }
      form("let", vector(*plain.flatten), *body) if plain.all?
    end

    def destructuring?(pattern) = [:vec_lit, :map_lit].include?(pattern.type.to_sym)

    # Return the names and values that the pattern binds, as a flat list, or
    # nil for a pattern this stage can't take apart.
    def destructured(pattern, value, names)
      case pattern.type
      when "vec_lit" then destructured_vector(pattern.children, value, names)
      when "map_lit" then destructured_map(pattern.children, value, names)
      else [pattern, value]
      end
    end

    # [a b & more :as all] v  ->  G__1 v a (nth G__1 0 nil) b (nth G__1 1 nil) more (nthnext G__1 2) all G__1
    def destructured_vector(items, value, names)
      temp = names.next
      bindings = [temp, value]
      items = items.dup
      index = 0
      until items.empty?
        item = items.shift
        case item.text
        when "&" then taken = destructured_rest(items.shift, form("nthnext", copy(temp), number(index)), names)
        when ":as" then taken = [items.shift, copy(temp)]
        else
          taken = destructured(item, form("nth", copy(temp), number(index), nil_form), names)
          index += 1
        end
        return unless taken

        bindings.concat(taken)
      end
      bindings
    end

    # Return nil for a map after `&`, which this stage can't take apart.
    def destructured_rest(pattern, value, names) = pattern.type == "map_lit" ? nil : destructured(pattern, value, names)

    # {a :a, :keys [b], :or {b 1}, :as m} v  ->  G__1 v a (get G__1 :a) b (get G__1 :b 1) m G__1
    def destructured_map(items, value, names)
      entries = items.each_slice(2).to_a
      defaults = entries.select { |key, _| key.text == ":or" }.flat_map { |_, map| map.children.each_slice(2).to_a }
      defaults = defaults.to_h { |name, default| [name.text, default] }
      temp = names.next
      bindings = entries.flat_map do |key, entry|
        taken = if key.type == "kwd_lit"
                  destructured_option(key.text, entry, temp, defaults)
                else
                  destructured(key, lookup(temp, entry, defaults[key.text]), names)
                end
        taken || (return nil)
      end
      [temp, value, *bindings]
    end

    # :as m  ->  m G__1
    # :keys [a]  ->  a (get G__1 :a)
    # :strs [a]  ->  a (get G__1 "a")
    # :syms [a]  ->  a (get G__1 (quote a))
    def destructured_option(option, value, temp, defaults)
      return [value, copy(temp)] if option == ":as"
      return [] if option == ":or"

      parts = option.match(MAP_OPTION)
      return unless parts && value.children.all? { |name| name.type == "sym" }

      namespace = parts[:namespace] ? "#{parts[:namespace]}/" : ""
      value.children.flat_map do |name|
        case parts[:kind]
        when "keys" then key = leaf(:kwd_lit, ":#{namespace}#{name.text}")
        when "strs" then key = literal(name.text)
        else key = form("quote", leaf(:sym, "#{namespace}#{name.text}"))
        end
        [name, lookup(temp, key, defaults[name.text])]
      end
    end

    def lookup(temp, key, default) = form("get", copy(temp), key, *[default].compact.map { |node| copy(node) })

    ### Functions ###

    # Write `defn` as a `def` of a function, and `defmacro` with its
    # function in the same form. Drop the docstring and the attribute map,
    # because they only add metadata. Leave a `defmacro` that is already in
    # this form.
    # (defn f "Adds one." {:added 1} [x] (inc x))  ->  (def f (fn* ([x] (inc x))))
    # (defmacro m [x] x)  ->  (defmacro m (fn* ([x] x)))
    def defn(definer, name, *rest)
      rest.shift if rest.first.type == "literal"
      rest.shift if rest.first.type == "map_lit"
      return if rest.one? && head(rest.first) == "fn*"

      form(definer, name, form("fn*", *arities(rest)))
    end

    # Write each function as an `fn*` with a list for each arity.
    # (fn [x] a)  ->  (fn* ([x] a))
    # (fn f ([x] a) ([x y] b))  ->  (fn* f ([x] a) ([x y] b))
    def fn_form(head, *args)
      name = args.shift if args.first&.type == "sym"
      return if head == "fn*" && args.first&.type == "list_lit"

      form("fn*", *[name].compact, *arities(args))
    end

    def arities(forms)
      forms = forms.first.type == "vec_lit" ? [list(*forms)] : forms.select { |form| form.type == "list_lit" }
      forms.map { |arity| without_destructured_parameters(arity) }
    end

    # Give each parameter that destructures a generated name, and destructure
    # it in a `let` around the body. Leave an arity as it is if this stage
    # can't take one of its patterns apart.
    # ([[a b] c] body)  ->  ([G__1 c] (let [G__2 G__1 a (nth G__2 0 nil) b (nth G__2 1 nil)] body))
    def without_destructured_parameters(arity)
      parameters, *body = arity.children
      return arity unless parameters.children.any? { |parameter| destructuring?(parameter) }

      names = gensyms
      bindings = []
      plain = parameters.children.map do |parameter|
        next parameter unless destructuring?(parameter)

        temp = names.next
        bindings.concat(destructured(parameter, copy(temp), names) || (return arity))
        temp
      end
      list(vector(*plain), form("let", vector(*bindings), *body))
    end

    ### The solution's own macros ###

    # Find the macros that the file defines with plain parameters and one
    # syntax-quoted template. Leave out a macro whose template uses one of
    # these macros, so that expanding them always ends.
    def student_macros(root)
      macros = root.children.filter_map { |form| student_macro(form) }.to_h
      macros.reject do |_, macro|
        names = []
        macro.template.each_descendant { |node| names << node.text if node.text }
        names.intersect?(macros.keys)
      end
    end

    # (defmacro unless [c & body] `(if ~c nil (do ~@body)))
    def student_macro(form)
      return unless head(form) == "defmacro"

      _, name, *rest = form.children
      rest.shift if rest.first&.type == "literal"
      parameters, template, *others = rest
      return unless others.empty? && parameters&.type == "vec_lit" && template&.type == "syn_quoting_lit"
      return unless name.type == "sym" && parameters.children.all? { |parameter| parameter.type == "sym" }

      names = parameters.children.map(&:text)
      required = names.take_while { |parameter| parameter != "&" }
      [name.text, Macro.new(required, names[required.size + 1], template.named_children.first)]
    end

    # Put each use's arguments in place of the template's unquotes, and a
    # generated name in place of each name that ends with `#`. Return nil if
    # the template unquotes code that isn't a parameter.
    # (unless x 1 2)  ->  (if x nil (do 1 2))
    def substituted_template(macro, args)
      names = gensyms
      context = {
        values: macro.parameters.zip(args).to_h,
        rest: macro.rest,
        rest_values: args.drop(macro.parameters.size),
        generated: Hash.new { |generated, name| generated[name] = names.next }
      }
      expansion = catch(:not_expandable) { substituted(macro.template, context) }
      expansion unless expansion.is_a?(Array)
    end

    # Return a node, or a list of nodes for `~@rest`.
    def substituted(node, context)
      target = node.named_children.first
      case node.type
      when "unquoting_lit" then unquoted(target, context)
      when "unquote_splicing_lit"
        throw :not_expandable unless rest?(target, context)
        context[:rest_values].map { |value| copy(value) }
      when "syn_quoting_lit" then throw :not_expandable
      when "sym" then copy(node.text.end_with?("#") ? context[:generated][node.text] : node)
      else
        node.dup.tap do |result|
          result.children = node.children.flat_map { |child| Array(substituted(child, context)) }
        end
      end
    end

    def unquoted(target, context)
      throw :not_expandable unless target.type == "sym"
      return copy(context[:values][target.text]) if context[:values].key?(target.text)
      return form("list", *context[:rest_values].map { |value| copy(value) }) if rest?(target, context)

      throw :not_expandable
    end

    def rest?(target, context) = target.type == "sym" && target.text == context[:rest]

    ### Names ###

    # Mark each name that a form defines as a definition or a local, so that
    # representation/spec.rb can list them.
    # (def limit 5)  ->  (def (definition limit) 5)
    # (let [total (* price 2)] total)  ->  (let [(local total) (* price 2)] total)
    def mark_the_names_each_form_defines!(root)
      root.each_descendant { |form| mark_the_names_defined_by(form) if head(form) }
    end

    def mark_the_names_defined_by(form)
      kind = head(form)
      _, *args = form.children
      mark(args.first, :definition) if DEFINITIONS.include?(kind)
      bind_pairs(args.first) if BINDINGS.include?(kind)
      mark_implementations(kind, args) if IMPLEMENTATIONS.include?(kind)

      case kind
      when "declare" then args.each { |name| mark(name, :definition) }
      when "fn*" then mark_function(args)
      when "defmethod" then bind(args.find { |arg| arg.type == "vec_lit" })
      when "catch" then mark(args[1], :local)
      when "letfn" then args.first.children.each { |function| mark_function(function.children) }
      end
    end

    # Mark a function's name and the parameters of each of its arities.
    # (fn* f ([x] ...) ([x y] ...))
    # (letfn [(f [x] ...)] ...)
    def mark_function(parts)
      name, *arities = parts.first.type == "sym" ? parts : [nil, *parts]
      mark(name, :local)
      parameters = arities.first.type == "vec_lit" ? [arities.first] : arities.map { |arity| arity.children.first }
      parameters.each { |vector| bind(vector) }
    end

    # Mark the fields of a record or a type, and the parameters of each method
    # it implements. Mark the methods that a protocol or an interface declares.
    # (defrecord Point [x y] Shape (area [this] ...))
    # (defprotocol Shape (area [this]))
    def mark_implementations(kind, args)
      bind(args[1]) if ["defrecord", "deftype"].include?(kind)
      args.each do |method|
        next unless method.type == "list_lit" && method.children[1]&.type == "vec_lit"

        mark(method.children.first, :definition) if ["defprotocol", "definterface"].include?(kind)
        bind(method.children[1])
      end
    end

    # Mark each pattern in a binding vector, and in each `:let` inside it.
    # (for [x xs :let [y (inc x)]] y)
    def bind_pairs(vector)
      vector.children.each_slice(2) do |pattern, value|
        if pattern.type != "kwd_lit" then bind(pattern)
        elsif pattern.text == ":let" then bind_pairs(value)
        end
      end
    end

    # Mark every name in a binding pattern as a local. A pattern is a symbol,
    # a vector of patterns, or a map such as {:keys [a] :as all, b :b}.
    def bind(pattern)
      case pattern&.type
      when "sym" then mark(pattern, :local)
      when "vec_lit" then pattern.children.each { |item| bind(item) }
      when "map_lit" then pattern.children.each_slice(2) { |key, value| bind_map_entry(key, value) }
      end
    end

    def bind_map_entry(key, value)
      return bind(key) unless key.type == "kwd_lit"

      case key.text
      when ":keys", ":strs", ":syms", ":as" then bind(value)
      when ":or" then value.children.each_slice(2) { |name, _| bind(name) }
      end
    end

    # Put a symbol inside a node of the type given, so that representation/spec.rb
    # can list it. `&` only marks the rest of the parameters, so it is never a
    # name.
    def mark(name, type)
      return unless name&.type == "sym" && name.text != "&"

      name.children = [leaf(:sym, name.text)]
      name.text = nil
      name.type = type.to_s
    end

    ### Building forms ###

    def head(form)
      first = form.children.first if form.type == "list_lit"
      first.text if first&.type == "sym"
    end

    def list(*items) = build(:list_lit, *items)
    def form(head, *args) = list(leaf(:sym, head), *args)
    def vector(*items) = build(:vec_lit, *items)
    def nil_form = leaf(:nil_lit, "nil")
    def number(value) = leaf(:num_lit, value.to_s)

    # A name that only macros make, which no solution can write.
    def generated = leaf(:gensym, "g")

    # The names that one expansion makes up, numbered from G__1, so that the
    # same code always gets the same names.
    def gensyms = Enumerator.new { |names| (1..).each { |count| names << leaf(:gensym, "G__#{count}") } }
  end
end
