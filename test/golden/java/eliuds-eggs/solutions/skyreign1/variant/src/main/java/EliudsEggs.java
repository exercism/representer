public class EliudsEggs {
    public int eggCount(int number) {
        int countOfOnes = 0;
        while (number != 0){
            if (number % 2 != 1){
                countOfOnes += 1;
            }
            number = number / 2;
        }
        return countOfOnes;
    }
}
