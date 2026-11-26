import java.util.regex.Pattern;

class LuhnValidator {
    boolean isValid(String candidate) {
	String cleaned = candidate.replaceAll(" ", "");
	int len = cleaned.length();
	int counter = 1;
	int sum = 0;

	if (len < 2 || candidate.matches("^.*[^ 0-9].*$")) return false;

	for (int i = len - 1; i >= 0; i--) {
	    int num = Character.getNumericValue(cleaned.charAt(i));

	    if (counter % 2 == 0) {
		num = num * 2 > 9 ? num * 2 - 9 : num * 2;
	    }
	    sum += num;  
	    counter++;
	}

	return sum % 10 == 0;
    }

    //public static void main(String... args) {
    //    System.out.println("res: " + new LuhnValidator().isValid("055"));
    //}
}