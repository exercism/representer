import java.lang.StringBuilder;

class ReverseString {
  
    String reverse(String string) {
    	return new StringBuilder(string).reverse().toString();
    }
}