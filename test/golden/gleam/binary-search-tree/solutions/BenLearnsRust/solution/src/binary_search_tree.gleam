import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

fn insert(tree: Tree, item: Int) -> Tree {
  case tree {
    Nil -> Node(item, Nil, Nil)
    Node(d, l, r) ->
      case item <= d {
        True -> Node(d, insert(l, item), r)
        False -> Node(d, l, insert(r, item))
      }
  }
}

pub fn to_tree(data: List(Int)) -> Tree {
  use acc, item <- list.fold(data, Nil)
  insert(acc, item)
}

fn to_list(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(d, l, r) -> list.append(to_list(l), [d, ..to_list(r)])
  }
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  data
  |> to_tree
  |> to_list
}
