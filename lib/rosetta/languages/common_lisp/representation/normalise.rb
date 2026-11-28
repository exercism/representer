# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to spellings that Common Lisp treats the same way.
module Rosetta::Languages::CommonLisp::Representation
  class Normalise < Rosetta::Engine::Normalise
    # Write a quoted `nil` as `nil`.
    # 'nil  ->  nil
    # '()  ->  nil
    rewrite "'nil", as: "nil"

    # Write the package `:common-lisp` by its nickname.
    # :common-lisp  ->  :cl
    rewrite ":common-lisp", as: ":cl"

    def call
      super.tap do |root|
        drop_the_function_mark_before_each_lambda!(root)
        drop_the_hash_before_each_keyword!(root)
        drop_docstrings!(root)
        keep_only_the_variable_of_each_for_and_with_clause!(root)
      end
    end

    private
    # Drop the `#'` before a lambda. A code pattern would match the lambda's
    # `defun` node and leave out the list around it, so this step keeps the
    # list.
    # #'(lambda (x) x)  ->  (lambda (x) x)
    def drop_the_function_mark_before_each_lambda!(root)
      transform(root, '(var_quoting_lit (list_lit (defun (defun_header (defun_keyword "lambda")))) @lambda)') do |match|
        match[:lambda]
      end
    end

    # Drop the `#` before a keyword, because `#:name` and `:name` name the
    # same package or symbol.
    # (defpackage #:two-fer)  ->  (defpackage :two-fer)
    def drop_the_hash_before_each_keyword!(root)
      each_node(root) do |node, _|
        node.children = node.children.reject.with_index do |child, index|
          child.type == "#" && node.children[index + 1]&.type == "kwd_lit"
        end
      end
    end

    # Drop the docstring of each function and global variable. A function's
    # string is only a docstring if more forms follow it, because otherwise
    # it is the value that the function returns.
    # (defun f () "Says hi." (g))  ->  (defun f () (g))
    # (defvar *x* 1 "A counter.")  ->  (defvar *x* 1)
    def drop_docstrings!(root)
      each_node(root) do |node, _|
        if node.type == "defun"
          values = node.children.select { |child| child.field == "value" }
          node.children.delete(values.first) if values.size > 1 && values.first.type == "literal"
        elsif node.type == "list_lit" && ["defvar", "defparameter", "defconstant"].include?(node.named_children.first&.text)
          forms = node.named_children
          node.children.delete(forms.last) if forms.size == 4 && forms.last.type == "literal"
        end
      end
    end

    # Replace each `for` and `with` clause of a loop with its variable.
    # for x from 1 to n  ->  x
    # with total = 0  ->  total
    def keep_only_the_variable_of_each_for_and_with_clause!(root)
      transform(root, "[(for_clause (variable) @name) (with_clause (variable) @name)]") { |match| match[:name] }
    end
  end
end
