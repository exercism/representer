import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Anagram {

	String anagram;

	public Anagram(String anagram) {
		this.anagram = anagram.toLowerCase();
	}

	public List<String> match(List<String> listPassed) {
		List<String> myList = new ArrayList<String>();
		for (String anag : listPassed) {
			String anagLowerCase = anag.toLowerCase();
			if (!anagLowerCase.equals(anagram) && sameCharacters(anagLowerCase, anagram)) {
				myList.add(anag);
			}
		}

		return myList;
	}

	private boolean sameCharacters(String original, String passed) {
		char[] originalArray = original.toCharArray();
		char[] passedArray = passed.toCharArray();
		Arrays.sort(originalArray);
		Arrays.sort(passedArray);
		return Arrays.equals(originalArray, passedArray);
	}

}