import java.util.Random;

class RobotName {

    String name

    static String getRandomChar() {
      Random randomGenerator = new Random();
      String letters = "QWERTYUIOPASDFGHJKLZXCVBNM";
      letters.charAt(randomGenerator.nextInt(letters.length() - 1))
    }
    
    static int getRandomDigit() {
      Random randomGenerator = new Random();
      randomGenerator.nextInt(10)
    }

    RobotName() {
        reset();
    }

    def reset() {
        name = getRandomChar() + getRandomChar() + getRandomDigit() + getRandomDigit() + getRandomDigit();
    }

}
