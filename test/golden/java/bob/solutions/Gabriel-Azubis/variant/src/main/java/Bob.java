class Bob {

    String hey(String input) {
        boolean isQuestion          = false;
        boolean isYelling           = true;
        boolean isSilence           = true;
        boolean hasLetters          = false;
        for (char c:input.toCharArray()) {
            if (!Character.isWhitespace(c)){
                isSilence = false;
            }
            if (Character.isAlphabetic(c) && !Character.isUpperCase(c)) {
                isYelling = false;
            }
            if (Character.isLetter(c)){
                hasLetters = true;
            }
        }
        if (input.trim().endsWith("?")){
            isQuestion = true;
        }

        if (isSilence) {
            return "Fine. Be that way!";
        }
        else if (isQuestion || isYelling && hasLetters) {
            return "Calm down, I know what I'm doing!";
        }
        else if (isQuestion) {
            return "Sure.";
        }
        else if (isYelling && hasLetters) {
            return "Whoa, chill out!";
        }
        else {
            return "Whatever.";
        }
        }

    }