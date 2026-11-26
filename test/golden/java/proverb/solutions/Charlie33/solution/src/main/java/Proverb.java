class Proverb {
    private String[] words = {"nail", "shoe", "horse", "rider", "message", "battle", "kingdom"};

    Proverb(String[] words) {
        this.words = words;
        recite();
    }

    String recite() {
        String output = "";

        if(words.length == 0) {
            return "";
        }

        for(int i = 0; i < words.length - 1; i++) {
            output += "For want of a " + words[i] + " the " + words[i+1] + " was lost.\n";
        }
        output += "And all for the want of a " + words[0] + ".";
        return output;
    }

}
