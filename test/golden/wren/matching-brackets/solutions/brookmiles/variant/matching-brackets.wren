var OPEN = "([{"
var CLOSE = ")]}"

class Brackets {

  static isPaired(s) {
    var stack = []
    for (c in s) {
      if(OPEN.contains(c)) {
        stack.add(c)
      } else  {
        var i = CLOSE.indexOf(c)
        if(i > 0) {
          if(stack.isEmpty) return false
          
          var opener = OPEN[i]
          if(stack[-1] != opener) return false
  
          stack.removeAt(-1)
        }
      }
    }
    return stack.isEmpty
  }
}