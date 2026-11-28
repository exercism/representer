# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each number, and a node for each word
# that the solution defines.
module Representer::Languages::Red::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets and quotes, because the node types already show them.
    # [a (b)]  ->  (block a (paren b))
    strip_tokens "[", "]", only_in: [:block, :function_spec, :map]
    strip_tokens "(", ")", only_in: :paren
    strip_tokens '"', only_in: [:string, :file]

    def call
      tree.tap do
        write_numbers_as_their_values!
        put_the_word_of_each_set_word_in_a_word!
        put_the_word_at_the_start_of_each_path_in_a_word!
        give_each_function_spec_a_type_of_its_own!
        mark_the_word_after_each_foreach_and_repeat!
      end
    end

    private
    ### Values ###

    # Write each number as its value. Red keeps integers and floats apart,
    # so `1` and `1.0` stay different.
    #
    # 1'000  ->  1000
    # 1.50  ->  1.5
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless node.named? && node.type == "number"

        text = number_value(node.text)
        node.text = text if text
      end
    end

    # Return a number's value as text, or nil if it can't be read, such as
    # `50%`.
    def number_value(text)
      return Representer::Engine::Numbers.integer(text, separator: "'", prefixes: {}).to_s if text.match?(/\A[-+]?\d['\d]*\z/)

      value = Representer::Engine::Numbers.decimal(text, separator: "'")
      value && Representer::Engine::Numbers.write_decimal(value)
    end

    ### Names ###

    # Put the word of each set word in a word of its own, so that
    # representation/spec.rb can rename it.
    # total:  ->  (set_word total)
    def put_the_word_of_each_set_word_in_a_word!
      transform(tree, "(set_word) @set_word") do |match|
        build(:set_word, leaf(:word, match.node.text.chomp(":")))
      end
    end

    # Put the word at the start of each path in a word of its own, so that
    # the engine renames it with the other uses of the word.
    # obj/x  ->  (path (path_start obj) x)
    def put_the_word_at_the_start_of_each_path_in_a_word!
      transform(tree, "(path_start) @start") do |match|
        build(:path_start, leaf(:word, match.node.text.chomp("/")))
      end
    end

    # Give each function's spec block a type of its own, so that
    # representation/spec.rb can list the parameters and locals it defines.
    # f: func [a /local b] [...]  ->  (function (set_word f) func (function_spec a /local b) ...)
    def give_each_function_spec_a_type_of_its_own!
      captured(tree, "(function spec: (block) @name)").each { |spec| spec.type = "function_spec" }
    end

    # Put the word that `foreach` and `repeat` give each item in a
    # loop_variable node, so that representation/spec.rb can rename it.
    # foreach c "ab" [...]  ->  foreach (loop_variable c) "ab" [...]
    def mark_the_word_after_each_foreach_and_repeat!
      each_node(tree) do |node, _|
        next unless ["block", "source_file"].include?(node.type)

        node.children.each_cons(2) do |loop, item|
          next unless loop.type == "word" && ["foreach", "repeat"].include?(loop.text) && item.type == "word"

          node.replace_child(item, build(:loop_variable, leaf(:word, item.text)))
        end
      end
    end
  end
end
