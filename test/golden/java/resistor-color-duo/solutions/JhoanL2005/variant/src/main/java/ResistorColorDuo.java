import java.util.Map;
import java.util.HashMap;

class ResistorColorDuo {
    String[]color = {"black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"};
    Map<String, Integer> Codes = new HashMap<>();
    
    int colorCode(String color) {
        switch (color){
            case "black":
                return 0;
            case "brown":
                return 1;
            case "red":
                return 2;
            case "orange":
                return 3;
            case "yellow":
                return 4;
            case "green":
                return 5;
            case "blue":
                return 6;
            case "violet":
                return 7;
            case "grey":
                return 8;
            case "white":
                return 9;
            default:
                throw new IllegalArgumentException();
        }
    }
    
    int value(String[] colors) {
        if(colors.length <= 2){
            throw new IllegalArgumentException();
        } 
        String[] ValueColor = {String.valueOf(colorCode(colors[0])), String.valueOf(colorCode(colors[1]))};
        return Integer.parseInt(ValueColor[0] + ValueColor[1]);
    }
}
