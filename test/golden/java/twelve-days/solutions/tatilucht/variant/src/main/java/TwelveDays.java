class TwelveDays {

    int verseNumber;

    String dayNumber = "";
    String start = "";

    String[] days = new String[] {"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"};
    String[] items = new String[] {"a Partridge in a Pear Tree", "two Turtle Doves", "three French Hens", "four Calling Birds", "five Gold Rings", "six Geese-a-Laying",
    "seven Swans-a-Swimming", "eight Maids-a-Milking", "nine Ladies Dancing", "ten Lords-a-Leaping", "eleven Pipers Piping", "twelve Drummers Drumming"};

    String verse(int verseNumber) {
        dayNumber = days[verseNumber-1];
        start = String.format("On the %s day of Christmas my true love gave to me: ", dayNumber);
        String iterationItems = "";
        String verse = "";

        if (verseNumber == 1) {
            verse = start + items[0] + ".\n";
        } else {
            while (verseNumber > 1) {
                iterationItems += items[verseNumber-1] + ", ";
                verseNumber--;
            }
            verse = start + iterationItems + "and " + items[0] + ".\n";
        }
        return verse;
    }


   String verses(int startVerse, int endVerse) {

        String verses = "";
        String lastverse = "";

        while(startVerse < endVerse){
            verses += this.verse(startVerse) + "\n";
            startVerse++;
        }
            lastverse = this.verse(endVerse);
        return verses - lastverse;

    }


  String sing() {
        String verses = "";
        verses += this.verses(1, 12);
        return verses;

    }


}