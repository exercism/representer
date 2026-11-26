import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn to_tree(data: List(Int)) -> Tree {
  list.fold(data, Nil, insert)
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  data
  |> to_tree()
  |> tree_to_sorted_list()
}

fn insert(tree: Tree, value: Int) -> Tree {
  case tree {
    Nil -> Node(value, Nil, Nil)
    Node(data, left, right) if value <= data ->
      value
      |> insert(left, _)
      |> Node(data, _, right)
    Node(data, left, right) ->
      value
      |> insert(right, _)
      |> Node(data, left, _)
  }
}

fn tree_to_sorted_list(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(data, left, right) ->
      [tree_to_sorted_list(left), [data], tree_to_sorted_list(right)]
      |> list.flatten()
  }
}
