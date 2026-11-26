import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn to_tree(data: List(Int)) -> Tree {
  list.fold(data, Nil, insert)
}

fn insert(tree: Tree, a: Int) -> Tree {
  case tree {
    Nil -> Node(a, Nil, Nil)
    Node(data, left, right) if a <= data -> Node(data, insert(left, a), right)
    Node(data, left, right) -> Node(data, left, insert(right, a))
  }
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  data |> to_tree |> to_list
}

fn to_list(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(data, left, right) -> list.append(to_list(left), [data, ..to_list(right)])
  }
}