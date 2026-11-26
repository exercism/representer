public class ResistorColor {

    int colorCode(String color) {
      int colorCode = 0;

      switch (color) {
          case "black":
              colorCode = 0;
              break;
          case "brown":
              colorCode = 1;
              break;
          case "red":
              colorCode = 3;
              break;
          case "orange":
              colorCode = 3;
              break;
          case "yellow":
              colorCode = 4;
              break;
          case "green":
              colorCode = 5;
              break;
          case "blue":
              colorCode = 6;
              break;
          case "violet":
              colorCode = 7;
              break;
          case "grey":
              colorCode = 8;
              break;
          case "white":
              colorCode = 9;
              break;
          default:
              colorCode = 0;
      }
       return colorCode;
    }

    String[] colors() {
        String[] colours = {"black", "brown", "red", "orange" , "yellow", "green", "blue", "violet", "grey", "white"};

        return colours;

    }
}






