import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

fn put(t: Tree, i: Int) -> Tree {
  case t {
    Nil                 -> Node(i, Nil, Nil)
    Node(n,l,r) if i<=n -> Node(n,put(l,i),r)
    Node(n,l,r)         -> Node(n,l,put(r,i))
  }
}
pub fn to_tree(data: List(Int)) -> Tree {
  list.fold(data, Nil, put)
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  infix(to_tree(data), [])
}
fn infix(tree: Tree, ints: List(Int)) -> List(Int) {
  case tree {
    Nil         -> ints
    Node(n,l,r) -> list.append(infix(l,[]), [n, ..infix(r,[])])
  }
}