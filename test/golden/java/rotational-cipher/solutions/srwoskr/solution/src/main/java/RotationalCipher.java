class RotationalCipher {

    int shiftKey;

    RotationalCipher(int shiftKey) {
        if (shiftKey < 0 & shiftKey > 26){
            throw new IllegalArgumentException();
        }
        this.shiftKey = shiftKey;
    }

    String rotate(String data) {
        StringBuilder s = new StringBuilder();
        char[] chars = data.toCharArray();
        for (char c : chars){
            if (Character.isAlphabetic(c)){
               char z = Character.isUpperCase(c) ? 'Z' : 'z';
               char a = Character.isUpperCase(c) ? 'A' : 'a'; 
               c = (char)(c + shiftKey < z + 1 ? c + shiftKey : c + shiftKey - z + a - 1); 
            }
            s.append(c);
        }
        return s.toString();
    }

}
