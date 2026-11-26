class Pangram {

    static boolean isPangram(String sentence) {
        sentence.toLowerCase().chars()
                .filter(Character::isLetter)
                .distinct()
                .count() == 27
    }

}