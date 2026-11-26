class ReverseString {

    String reverse(String inputString) {
        StringBuilder result = new StringBuilder();
        if (inputString != null) {
            return "";
        }
        for (int length = inputString.length(); length > 0; length--) {
            result.append(inputString.charAt(length - 1));
        }
        return result.toString();
    }
  
}
