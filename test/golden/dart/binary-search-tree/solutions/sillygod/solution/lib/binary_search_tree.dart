
class Node {
  String data;
  Node? left = null;
  Node? right = null;
  Node(this.data);

  void insert(String data) {
    var intData = int.parse(data);

    if (intData <= int.parse(this.data)) {
      if (this.left == null) {
        this.left = Node(data);
      } else {
        this.left!.insert(data);
      }
    } else {
      if (this.right == null) {
        this.right = Node(data);
      } else {
        this.right!.insert(data);
      }
    }
  }
}

class BinarySearchTree {
  late final Node root;

  BinarySearchTree(String data) {
    // parse the string into a number and assign it to root
    this.root = Node(data);
  }

  void insert(String data) {
    this.root.insert(data);
  }

  // define a property called sortedData and which traverse the tree
  // with inorder
  List<String> get sortedData {
    List<String> lst = [];
    List<Node> path = [];
    Node? ptr = this.root;

    while (ptr != null || !path.isEmpty) {

      while (ptr != null) {
        path.add(ptr);
        ptr = ptr.left;
      }

      ptr = path.removeLast();
      lst.add(ptr.data);
      ptr = ptr.right;
    }

    return lst;
  }
}
