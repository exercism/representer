import java.util.Arrays;

class IsogramChecker {

    boolean isIsogram(String phrase) {
        char previous;
        char[] chars = phrase.toLowerCase().replaceAll("-| ","").toCharArray();

        //one more control not necessary to pass tests
        String alphabet = "abcdefghijklmnopqrstuvwxyz";
        for(char c : chars) {
            if(alphabet.indexOf(c) == -1)
                return false;
        }
        //
        
        Arrays.sort(chars);
        
        
        for(int i = 1; i<chars.length; i++) {
            if(chars[i] == chars[i-1])
                return false;
        }

        return true;
    }

}
