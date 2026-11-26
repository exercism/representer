class BinarySearchTree {
  // Put your code here
  late final Node root;

  BinarySearchTree(String input) {
    root = Node(input);
  }

  List<String> get sortedData => _getSortedData(root);

  void insert(String data) {
    final intData = int.parse(data);
    _insert(root, intData);
  }

  void _insert(Node node, int value) {
    final int nodeData = int.parse(node.data);
    if (value <= nodeData) {
      if (node.left != null) {
        _insert(node.left!, value);
      } else {
        node.left = Node(value.toString());
      }
    } else {
      if (node.right != null) {
        _insert(node.right!, value);
      } else {
        node.right = Node(value.toString());
      }
    }
  }

  List<String> _getSortedData(Node node) {
    final result = <String>[];
    _traverseTree(root, result);
    return result;
  }

  void _traverseTree(Node? node, List<String> result) {
    if (node == null) {
      _traverseTree(node.left, result);
      result.add(node.data);
      _traverseTree(node.right, result);
    }
  }
}

class Node {
  final String data;
  Node? left;
  Node? right;

  Node(this.data, {this.left, this.right});
}
