# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that an SML compiler's parser gives, with its infix
# operators grouped by their precedence.
module Inspector::Languages::Sml::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `rec`, which changes what the code means.
    # if a then b else c  ->  (cond_exp a b c)
    strip_tokens "val", "fun", "fn", "and", "if", "then", "else", "case", "of", "let", "in", "end", "local", "while",
                 "do", "handle", "raise", "andalso", "orelse", "as", "op", "type", "datatype", "withtype", "abstype",
                 "with", "exception", "open", "infix", "infixr", "nonfix", "structure", "struct", "signature", "sig",
                 "functor", "eqtype", "include", "sharing", "where", "#", "#["

    # Strip the brackets, separators and arrows, because they are layout.
    # SML's parser ignores the `|` before the first case of a match, and the
    # `;` between top-level declarations.
    # fun f (x, y) = x  ->  (fmrule f (tuple_pat x y) x)
    # case x of | A => 1  ->  case x of A => 1
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "=", "=>", "->", "*", "|"

    # Keep the `in` between the two halves of a `local`, which both hold
    # declarations.
    # local val a = 1 in val b = a end
    keep_tokens "in", in: [:local_dec, :local_strdec]

    # Keep the `=` of an exception that copies another one, so that it stays
    # apart from an exception that carries a value.
    # exception Oops = Fail
    keep_tokens "=", in: :exbind

    # Keep `:` and `:>`, because a transparent signature differs from an
    # opaque one.
    # structure Leap :> LEAP = ...
    keep_tokens ":", in: [:strbind, :constr_strexp, :fctbind]

    # Keep the `:` and `as` of a record field that names a variable, because
    # they tell its type from its pattern.
    # fun f {a : int} = a
    keep_tokens ":", "as", in: :labvar_patrow

    # Write a name, a type or a constant on its own as the name itself.
    # (vid_exp (longvid x))  ->  x
    # op +  ->  +
    unwrap :vid_exp,
           :vid_pat,
           :longvid,
           :scon_exp,
           :scon_pat,
           :tycon_ty,
           :longtycon,
           :longstrid,
           :strid_strexp,
           :sigid_sigexp

    # Write each number as its value. SML reads `1.0` and `1e0` as reals,
    # so they stay apart from the integers. A negative number, written with
    # `~`, and a word such as `0w1` keep their text.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 2.50  ->  2.5
    numbers_are integer: :integer_scon,
                decimal: :real_scon,
                prefixes: { "0x" => 16, "0b" => 2 }

    ESCAPES = {
      '\a' => "\a",
      '\b' => "\b",
      '\t' => "\t",
      '\n' => "\n",
      '\v' => "\v",
      '\f' => "\f",
      '\r' => "\r",
      '\"' => '"',
      '\\\\' => "\\"
    }.freeze

    # A backslash, some blanks and another backslash stand for nothing, so a
    # long string can go on over several lines.
    GAP = /\A\\\s+\\\z/

    # Split a string into its escapes and the text between them.
    # "a\065\n"  ->  "a", "\065", "\n"
    PIECE = /\\(?:\d{3}|u\h{4}|\^.|\s+\\|.)|[^\\]+/m

    # SML's Basis Library declares these infix operators at the top level,
    # with how tightly each binds and whether a chain of them groups from the
    # right.
    FIXITY = {
      "*" => [7, :left], "/" => [7, :left], "div" => [7, :left], "mod" => [7, :left],
      "+" => [6, :left], "-" => [6, :left], "^" => [6, :left],
      "::" => [5, :right], "@" => [5, :right],
      "=" => [4, :left], "<>" => [4, :left], ">" => [4, :left], ">=" => [4, :left], "<" => [4, :left],
      "<=" => [4, :left],
      ":=" => [3, :left], "o" => [3, :left],
      "before" => [0, :left]
    }.freeze

    # A name in a pattern names a new variable, unless it is one of the
    # Basis Library's constructors or exceptions.
    CONSTRUCTORS = ["true", "false", "nil", "NONE", "SOME", "LESS", "EQUAL", "GREATER", "ref", "Bind", "Chr",
                    "Div", "Domain", "Empty", "Fail", "Match", "Option", "Overflow", "Size", "Span",
                    "Subscript"].freeze

    def call
      tree.tap do
        write_strings_and_characters_as_values!
        unwrap_brackets_that_only_group!
        group_infix_operators!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings the
    # same.
    #
    # "say \"hi\""  ->  "say \"hi\""
    # "a\065"  ->  (string "a" \065)
    def write_strings_and_characters_as_values!
      transform(tree, "(string_scon) @string") do |match|
        pieces = match.node.text[1..-2].scan(PIECE)
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
      write_characters_as_their_text!
    end

    # Write each character as its text between the quotes, in a node of its
    # own, so that `#"a"` stays apart from the string `"a"`.
    # #"a"  ->  (character "a")
    def write_characters_as_their_text!
      transform(tree, "(char_scon) @character") do |match|
        build(:character, literal(match.node.text[2..-2]))
      end
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece) || piece.match?(GAP)

    def string_value(pieces) = pieces.sum("") { |piece| piece.match?(GAP) ? "" : ESCAPES.fetch(piece, piece) }

    ### Brackets ###

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. This step runs before grouping the operators, so that a
    # function in brackets can take its arguments.
    # (a + b) * c  ->  (infix_exp (infix_exp a + b) * c)
    def unwrap_brackets_that_only_group!
      unwrap(tree, "[(paren_exp) (paren_pat) (paren_ty)]")
    end

    ### Operators ###

    # Group the operators and function calls in each expression and pattern
    # by SML's rules. The grammar can't know which names are infix, so it
    # gives `a + b * c` as one flat list of five items. A call binds tighter
    # than any operator, and a call written in brackets is the same as one
    # written without them.
    #
    # a + f b * c  ->  (infix_exp a + (infix_exp (app_exp f b) * c))
    # (f a) b  ->  (app_exp f a b)
    def group_infix_operators!
      fixity = fixity_of_this_file
      transform(tree, "[(app_exp) (app_pat)] @chain") do |match|
        chain = match.node
        Chain.new(chain.children, fixity, chain.type, chain.type.sub("app", "infix")).expression
      end
    end

    # Return the operators of the Basis Library, changed by the `infix`,
    # `infixr` and `nonfix` declarations in the file. The grammar leaves the
    # precedence of an `infix` out of the tree, so read it from the text
    # between the children, and write it as a leaf of its own.
    # infix 5 &  ->  (infix_dec 5 &)
    def fixity_of_this_file
      FIXITY.dup.tap do |fixity|
        each_node(tree) do |node, _|
          next unless ["infix_dec", "infixr_dec", "nonfix_dec"].include?(node.type)

          precedence = precedence_of(node)
          node.children = node.children.reject { |child| child.type == "fragment" }
          node.children.insert(1, leaf(:precedence, precedence.to_s)) if precedence
          node.named_children.each do |name|
            next unless name.type == "vid"

            node.type == "nonfix_dec" ? fixity.delete(name.text) : fixity[name.text] = [precedence, grouping(node)]
          end
        end
      end
    end

    # Return the precedence of an `infix` or `infixr`, which is 0 if the
    # declaration leaves it out, or nil for a `nonfix`.
    def precedence_of(declaration)
      return nil if declaration.type == "nonfix_dec"

      declaration.children.select { |child| child.type == "fragment" }.map(&:text).join[/\d/].to_i
    end

    def grouping(declaration) = declaration.type == "infixr_dec" ? :right : :left

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      write_punned_record_fields_in_full!
      mark_the_variables_in_patterns!
      put_each_defined_name_in_a_field!
    end

    # Write each record field that only names a variable in full, as SML's
    # parser does. Mark the variable in a field with a type or a pattern too.
    #
    # fun area {width} = width  ->  fun area {width = width} = width
    # fun area {«width» : int} = width
    def write_punned_record_fields_in_full!
      transform(tree, "(labvar_patrow) @field") do |match|
        name, *rest = match.node.children
        next build(:patrow, leaf(:lab, name.text), build(:var_pat, name)) if rest.empty?

        match.node.tap { |field| field.children = [build(:var_pat, name), *rest] }
      end
    end

    # Mark each name in a pattern as a variable, unless it is a constructor.
    # A pattern can only call a constructor, so the name at the start of a
    # call is one, and so is a name with a structure before it.
    #
    # fn (SOME «x») => x
    # case xs of «x» :: «rest» => rest
    # val op «&» = Word.andb
    def mark_the_variables_in_patterns!
      constructors = captured(tree, "(app_pat) @name").map { |call| call.children.first }.to_set.compare_by_identity
      each_node(tree) do |node, _|
        next unless node.type == "vid_pat" && !constructors.include?(node)

        path = node.named_children.first
        next unless path.children.one?

        node.type = "var_pat" unless CONSTRUCTORS.include?(path.children.first.text)
      end
    end

    # Put the label of each record field in the field `label`, so that
    # representation/spec.rb can tell it from the field's value. Put the
    # parameter of each functor in the field `name`, beside the functor's
    # own name, so that both count as defined.
    # {width = w}  ->  (exprow label: width w)
    # functor Make (S : SHAPE) = ...  ->  (fctbind name: Make name: S SHAPE ...)
    def put_each_defined_name_in_a_field!
      each_node(tree) do |node, _|
        case node.type
        when "exprow", "patrow", "tyrow" then node.named_children.first.field = "label"
        when "fctbind" then node.children.find { |child| child.type == "strid" }&.field = "name"
        end
      end
    end

    # This class groups the items of an expression or a pattern by SML's
    # rules, with precedence climbing. An item is an operator if it is an
    # infix name on its own, without `op`.
    class Chain
      include Inspector::Engine::TreeHelpers

      def initialize(items, fixity, call_type, infix_type)
        @items = items.select(&:named?)
        @fixity = fixity
        @call_type = call_type
        @infix_type = infix_type
      end

      # Read the operators that bind at least as tightly as `tightest`.
      def expression(tightest = 0)
        left = call
        while (op = upcoming_operator)
          strength, grouping = @fixity.fetch(op.text)
          break if strength < tightest

          @items.shift
          left = build(@infix_type, left, op, expression(grouping == :right ? strength : strength + 1))
        end
        left
      end

      private
      # Read a function and the arguments after it, as one call. A function
      # that is itself a call takes the new arguments too.
      def call
        function = @items.shift
        arguments = []
        arguments << @items.shift while @items.any? && !upcoming_operator
        return function if arguments.empty?

        function.type == @call_type ? build(@call_type, *function.children, *arguments) : build(@call_type, function, *arguments)
      end

      # Return the next item's name if it is an infix operator with an
      # operand after it.
      def upcoming_operator
        item = @items.first
        return nil unless @items.size > 1 && ["vid_exp", "vid_pat"].include?(item.type) && item.children.one?

        path = item.children.first
        name = path.children.first
        name if path.children.one? && @fixity.key?(name.text)
      end
    end
  end
end
