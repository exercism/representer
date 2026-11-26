public static class LineUp
{
    public static string Format(string name, int number)
    {
        string end;
        if(number%100>=11 && number%100<=13) end = "th";
        else{
            switch(number%10){
                case 1: end = "st";
                    break;
                case 2: end = "nd";
                    break;
                case 3: end = "rd";
                    break;
                default: end = "th";
                    break;
            }
        }
        return $"{name}, you are the {number}{end} customer we serve today. Thank you!";
    }
}