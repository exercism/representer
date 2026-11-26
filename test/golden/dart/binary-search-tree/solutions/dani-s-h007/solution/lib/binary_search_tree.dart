class Node {
  String data;
  Node? left, right;
  Node(this.data);
}

class BinarySearchTree {
  final Node root;
  BinarySearchTree(String value) : root = Node(value);

  void insert(String value) {
    var node = root;
    while (true) {
      if (value.compareTo(node.data) <= 0) {
        if (node.left == null) {
          node.left = Node(value);
          return;
        }
        node = node.left!;
      } else {
        if (node.right == null) {
          node.right = Node(value);
          return;
        }
        node = node.right!;
      }
    }
  }

  List<String> get sortedData {
    final res = <String>[];
    void traverse(Node? n) {
      if (n == null) return;
      traverse(n.left);
      res.add(n.data);
      traverse(n.right);
    }
    traverse(root);
    return res;
  }
}
