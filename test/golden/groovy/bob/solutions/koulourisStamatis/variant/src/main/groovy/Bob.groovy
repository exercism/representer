class Bob {
    static String response(String input) {
        if(isQuestion(input) || isYelling(input)){
            return "Calm down, I know what I'm doing!"    
        }else if(isYelling(input)){
            return "Whoa, chill out!"
        }else if(isQuestion(input)){
            return "Sure."
        }else if (isWhiteSpaces(input)){
            return "Fine. Be that way!"
        }else {
            return "Whatever."
       }        
    }

   static boolean isQuestion(String input){
        input = input.trim()
        return input.length() > 0 && input[input.length() -1] == '?'
    }

  static  boolean isYelling(String input){
        def letters = input.findAll(/[A-Za-z]/)
        return !letters.isEmpty() && letters.every { it == it.toUpperCase() }
    }

   static boolean isWhiteSpaces(String input){
        return input.trim().isEmpty()
    }
}
