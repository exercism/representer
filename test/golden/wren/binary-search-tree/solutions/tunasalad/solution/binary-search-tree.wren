class BinarySearchTree {
  construct with(item) {init_items([item])}
  construct withAll(items) {init_items(items)}
  init_items(items) {
    _root = null
    for (x in items) _root = BinarySearchTree.insert(_root, x)
  }

  data {_root}
  sortedData {
    var res = []
    BinarySearchTree.collect(_root, res)
    return res
  }
  static insert(tree, data) {
    if (tree) {
      var res = {
        "data": tree["data"],
        "left": tree["left"],
        "right": tree["right"],
      }
      if (data <= tree["data"]) {
        res["left"] = insert(tree["left"], data)
      } else {
        res["right"] = insert(tree["right"], data)
      }
      return res
    } else {
      return {
        "data": data,
        "left": null,
        "right": null,
      }
    }
  }
  static collect(tree, list) {
    if (tree) {
      collect(tree["left"], list)
      list.add(tree["data"])
      collect(tree["right"], list)
    }
  }
}
