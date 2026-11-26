class ResistorColorTrio {
    static int colorCode(String color) {
        final String[] colors = {
            "black", "brown", "red", "orange", "yellow",
            "green", "blue", "violet", "grey", "white"
        };
        for (int i = 0; i < colors.length; i++)
            if (color == colors[i])
                return i;
        return -1;
    }

    static String label(String[] colors) {
        int zeros = colorCode(colors[2]),
            ones = colorCode(colors[1]),
            tens = colorCode(colors[0]),
            num = 10 * tens + ones;
        if (ones == 0) {
            num /= 10;
            if (num == 0)
                zeros = 0;
            else
                zeros++;
        }
        String prefix = switch (zeros / 3) {
            case 3 -> "giga";
            case 2 -> "mega";
            case 1 -> "kilo";
            default -> "";
        };
        for (int i = 0; i < zeros % 3; i++)
            num *= 10;
        return Integer.toString(num)
            + " "
            + prefix
            + "ohms";
    }
}
