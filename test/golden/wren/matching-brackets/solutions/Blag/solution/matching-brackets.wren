class Brackets {
  static isPaired(s) {
    var stack = []
    for (c in s) {
      if (c == "[" || c == "(" || c == "{") {
        stack.add(c)
      } else if (c == "]") {
        if (stack.isEmpty || stack.removeAt(-1) != "[") return false
      } else if (c == ")") {
        if (stack.isEmpty || stack.removeAt(-1) != "(") return false
      } else if (c == "}") {
        if (stack.isEmpty || stack.removeAt(-1) != "{") return false
      }
    }
    return stack.isEmpty
  }
}