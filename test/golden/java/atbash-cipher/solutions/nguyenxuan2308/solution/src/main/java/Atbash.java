
public class Atbash {

	public String encode(String string) {
		string = string.toLowerCase();
		String rs = "";
		int dem = 0;
		String s = "";
		for (int i = 0; i < string.length(); i++) {
			if (string.charAt(i) == '.' || string.charAt(i) == ' ' || string.charAt(i) == ',') {
				s = s;
			} else {
				s += string.charAt(i);
			}
		}
		string = s;
		for (int i = 0; i < string.length(); i++) {
			if (Character.isDigit(string.charAt(i))) {
				rs += string.charAt(i);
				dem++;
				if (dem % 5 == 0) {
					rs += " ";
				}
			} else {
				char a = (char) ('z' - (string.charAt(i) - 'a'));
				rs += a;
				dem++;
				if (dem % 5 == 0) {
					rs += " ";
				}
			}

		}

		rs = rs.trim();
		return rs;
	}

	public String decode(String string) {
		string = string.toLowerCase();
		String rs = "";
		int dem = 0;
		String s = "";
		for (int i = 0; i < string.length(); i++) {
			if (string.charAt(i) == '.' || string.charAt(i) == ' ' || string.charAt(i) == ',') {
				s = s;
			} else {
				s += string.charAt(i);
			}
		}
		string = s;
		for (int i = 0; i < string.length(); i++) {
			if (Character.isDigit(string.charAt(i))) {
				rs += string.charAt(i);
			} else {
				char a = (char) (('z' - string.charAt(i)) + 'a');
				rs += a;
				dem++;
			}

		}

		rs = rs.trim();
		return rs;
	}

}