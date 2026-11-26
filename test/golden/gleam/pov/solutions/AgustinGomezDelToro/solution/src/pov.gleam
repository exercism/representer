import gleam/bool
import gleam/list
import gleam/result

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  use <- bool.guard(tree.label == from, Ok(tree))
  use path <- result.try(root_to_node(tree, from, []))

  let assert Ok(rest) = list.rest(path) 
  swap_parent_child(tree, rest) |> Ok
}

fn swap_parent_child(parent: Tree(a), path: List(a)) -> Tree(a) {
  case path {
    [] -> parent
    [f, ..rest] -> {
      let assert Ok(#(child, new_children)) = parent.children
        |> list.pop(fn(ch) { ch.label == f })
      let parent = Tree(..parent, children: new_children)
      let child = Tree(..child, children: [parent, ..child.children])
      swap_parent_child(child, rest)
    }
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  use pov_tree <- result.try(from_pov(tree, from))
  root_to_node(pov_tree, to, [])
}

fn root_to_node(tree: Tree(a), to: a, path: List(a)) -> Result(List(a), Nil) {
  case tree.label == to {
    True -> Ok(list.reverse([to, ..path]))
    False -> tree.children
      |> list.find_map(root_to_node(_, to, [tree.label, ..path]))
  }
}