// Usage
// If the given name is "Alice", the result should be "One for Alice, one for me."
// If no name is given, the result should be "One for you, one for me."
//
fun twofer(name: String? = null): String = 
    if(name != null) "One for $name, one for me."
    else "One for you, one for me."