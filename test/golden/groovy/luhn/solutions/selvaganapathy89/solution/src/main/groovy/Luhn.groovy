class Luhn {
    static boolean valid(String value) {
        if(!value.matches("[0-9 ]+") || value.trim().length()<2) {
			return false;
		}
		Collection valueArr = value.replace(' ','').reverse().collect();
		int sum = 0;
		valueArr.eachWithIndex { it,i -> (i+1) % 2 == 0 ? sum += ((Integer.valueOf("${it}")*2)>9?(Integer.valueOf("${it}")*2)-9:(Integer.valueOf("${it}")*2)):  (sum += Integer.valueOf("${it}")); }
		return (sum%10 == 0);
    }
}
