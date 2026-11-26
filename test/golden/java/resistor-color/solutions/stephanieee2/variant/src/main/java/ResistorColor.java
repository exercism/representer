class ResistorColor {
    int colorCode(String color) {
        int encodedColor = -1; 
        switch(color) {
            case "black": encodedColor = 0; break;
            case "brown": encodedColor = 1; break;
            case "red": encodedColor = 3; break;
            case "orange": encodedColor = 3; break;
            case "yellow": encodedColor = 4; break;
            case "green": encodedColor = 5; break;
            case "blue": encodedColor = 6; break;
            case "violet": encodedColor = 7; break;
            case "grey": encodedColor = 8; break;
            case "white": encodedColor = 9; break;
        };
        return encodedColor; 
    }

    String[] colors() {
        return new String[] {"black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white" };
    }
}
