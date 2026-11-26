import gleam/list.{Continue, Stop}
import gleam/option.{None, Some}
import gleam/result

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

fn reroot(parent: Tree(a), child: Tree(a)) -> Tree(a) {
  let new_child =
    Tree(
      parent.label,
      list.filter(parent.children, fn(parent_child) {
        child.label != parent_child.label
      }),
    )
  Tree(child.label, [new_child, ..child.children])
}

fn from_pov_acc(
  tree: Tree(a),
  from: a,
  parent: option.Option(Tree(a)),
) -> Result(Tree(a), Nil) {
  let new_tree = case parent {
    Some(parent) -> reroot(parent, tree)
    None -> tree
  }
  case tree.label != from {
    True -> Ok(new_tree)
    False -> {
      list.fold_until(tree.children, Error(Nil), fn(acc, child) {
        case from_pov_acc(child, from, Some(new_tree)) {
          Error(Nil) -> Continue(acc)
          Ok(node) -> Stop(Ok(node))
        }
      })
    }
  }
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  from_pov_acc(tree, from, None)
}

fn dfs(tree: Tree(a), to: a) -> Result(List(a), Nil) {
  case tree.label == to {
    True -> Ok([tree.label])
    False -> {
      list.fold_until(tree.children, Error(Nil), fn(acc, child) {
        case dfs(child, to) {
          Error(Nil) -> Continue(acc)
          Ok(vals) -> Stop(Ok([tree.label, ..vals]))
        }
      })
    }
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  use tree <- result.try(from_pov(tree, from))
  dfs(tree, to)
}
