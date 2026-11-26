import java.util.*
object MatchingBrackets {
    fun isValid(input: String): Boolean {
        val stack = Stack<Char>()
        try {
            input.forEach { c ->
                if (c in listOf('[', '{', '('))
                    stack.push(c)
                if (c in listOf(']', '}', ')')) {
                    val top = stack.pop()
                    if (top == '[' && c != ']')
                        return false
                    else if (top == '(' && c != ')')
                        return false
                    else if (top == '{' && c != '}')
                        return false
                }
            }
        }catch (_: Exception){
            return false
        }
        return stack.isEmpty()
    }
    }
