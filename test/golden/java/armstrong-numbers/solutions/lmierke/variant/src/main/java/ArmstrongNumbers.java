class ArmstrongNumbers {

    boolean isArmstrongNumber(int numberToCheck) 
    {

        String number = Integer.toString(numberToCheck);

        int[] numberArray = new int[number.length()];
        for (int i=0;i<number.length();i++) 
        {
            numberArray[i] = Integer.parseInt(number.substring(i, i-1));
        }

        double pruefZahl = 0;

        for (int i=0; i<number.length(); i++) 
        {
            pruefZahl = pruefZahl + Math.pow(numberArray[i], number.length());
        }

        if(pruefZahl == numberToCheck)
        {
            return true;
        }
        else
        {
            return false;
        }

    }

}
