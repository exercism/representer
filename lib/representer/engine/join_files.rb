module Representer::Engine
  # Joins the files' trees into one, in an order that depends only on
  # their code, so the files' names and order never change the
  # representation.
  #
  # It writes each tree out with every name that will be renamed left
  # blank, and sorts the trees by that. Trees that are the same apart from
  # those names are sorted by the names as written. A staged language
  # marks those names on the leaves (see RenameUserDefinedNodes), and
  # another language gives them as names (see Names).
  #
  # A rule may have replaced a file's root, so such a file joins as one
  # child.
  class JoinFiles
    include Mandate

    initialize_with :trees, :root_type, :names

    def call
      return trees.first if trees.one?

      sorted = trees.sort_by { |tree| [Serialize.(tree, names, blank: true), Serialize.(tree, nil)] }
      Node.new(root_type, sorted.flat_map { |tree| tree.type == root_type ? tree.children : [tree] })
    end
  end
end
