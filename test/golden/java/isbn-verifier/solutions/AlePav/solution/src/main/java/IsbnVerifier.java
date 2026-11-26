class IsbnVerifier {
    boolean isValid(String stringToVerify) {
        boolean valid = false;
        stringToVerify = removeDashes(stringToVerify);
        if(stringToVerify.length()!=10) return false;
        int n;
        int verifiedNumber=0;
        for (int i = 0; i < stringToVerify.length(); i++) {
            try{
                n = Integer.parseInt(stringToVerify.substring(i,i+1));
                verifiedNumber += n*(stringToVerify.length()-i);
            }catch(NumberFormatException e){
                if(stringToVerify.substring(i).equalsIgnoreCase("x")){
                    verifiedNumber+=10*(stringToVerify.length()-i);
                }else{
                    return false;
                }
            }
        }
        valid = verifiedNumber%11==0;
        return valid;
    }

    public static String removeDashes(String isbn){
        char c;
        String isbnNoDashes="";
        for (int i = 0; i < isbn.length(); i++) {
            c= isbn.charAt(i);
            if(c != '-' && c!=' '){
                isbnNoDashes+=String.valueOf(c);
            }
        }
        return isbnNoDashes;
    }

}
