class BottleSong {

    String recite(int startBottles, int takeDown) {
        
        StringBuilder output = new StringBuilder();

        String btl = BottleSingularPlural(startBottles);
        String numberWord = GetNumberAsWord(startBottles);
        int lastRound = startBottles - takeDown;

        for (int b = startBottles; b >= lastRound; b--) {

            String firstLine = GenerateVerse(numberWord, btl);

            btl = BottleSingularPlural(b-1);
            numberWord = GetNumberAsWord(b-1);

            String lastLine = "There'll be " + GenerateVerse(numberWord.toLowerCase(), btl);

            output.append(String.format("%s%sAnd if one green bottle should accidentally fall,\n%s", firstLine, firstLine, lastLine));
            if (b != lastRound + 1)
                output.append("\n");
        }
        return output.toString();
    }

    private String GenerateVerse(String number, String btl) {
        return String.format("%s green %s hanging on the wall%c\n", number, btl, (Character.isLowerCase(number.charAt(0))) ? '.' : ',');
    }

    private String BottleSingularPlural(int number) {
        if (number == 1)
            return "bottle";
        else return "bottles";
    }

    private String GetNumberAsWord(int number) {
        switch (number) {
            case 1:
                return BottleNumbers.ONE.GetNumberWord();
            case 2:
                return BottleNumbers.TWO.GetNumberWord();
            case 3:
                return BottleNumbers.THREE.GetNumberWord();
            case 4:
                return BottleNumbers.FOUR.GetNumberWord();
            case 5:
                return BottleNumbers.FIVE.GetNumberWord();
            case 6:
                return BottleNumbers.SIX.GetNumberWord();
            case 7:
                return BottleNumbers.SEVEN.GetNumberWord();
            case 8:
                return BottleNumbers.EIGHT.GetNumberWord();
            case 9:
                return BottleNumbers.NINE.GetNumberWord();
            case 10:
                return BottleNumbers.TEN.GetNumberWord();
            default:
                return "no";
        }
    }
}