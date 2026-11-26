class RomanNumerals {
    RomanNumerals() {
        Integer.metaClass.getRoman = { ->
            convert(delegate as Integer)
        }
    }

    static convert(Integer arabic){
        //Set up initial roman numbers data structure
        Map<String,List<String>> romanNumbersMap = new HashMap<>()
        romanNumbersMap.put(1,["I","V"])
        romanNumbersMap.put(2,["X","L"])
        romanNumbersMap.put(3,["C","D"])
        romanNumbersMap.put(4,["M"])

        //Treat number as string for easy manipulation (Length and specific characters)
        String arabicString = String.valueOf(arabic)
        Integer arabicPositions = arabicString.length()

        //Initialize final roman number string
        String romanNumber = ""

        while(arabicPositions > 0){
            //Digit to evaluate
            Integer arabicDigit = Integer.valueOf(arabicString[0])

            //Handle each case accordingly. Depending of length of number, roman number map has a different assignment
            if(arabicDigit >= 1 && arabicDigit <= 3){
                arabicDigit.times{
                    romanNumber += romanNumbersMap.get(arabicPositions)[0]
                }
            }
            if(arabicDigit == 4){
                romanNumber += romanNumbersMap.get(arabicPositions)[0] + romanNumbersMap.get(arabicPositions)[1]
            }
            if(arabicDigit == 5){
                romanNumber += romanNumbersMap.get(arabicPositions)[1]
            }
            if(arabicDigit >= 6 && arabicDigit <= 8){
                romanNumber += romanNumbersMap.get(arabicPositions)[1]
                (arabicDigit - 5).times{
                    romanNumber += romanNumbersMap.get(arabicPositions)[0]
                }
            }
            if(arabicDigit == 9){
                romanNumber += romanNumbersMap.get(arabicPositions)[0] + romanNumbersMap.get(arabicPositions + 1)[0]
            }

            if(arabicPositions === 1)
                break

            //Remove first digit to start analizing next one
            arabicString = arabicString.substring(1)
            arabicPositions = arabicString.length()
        }
        return romanNumber
    }
}
