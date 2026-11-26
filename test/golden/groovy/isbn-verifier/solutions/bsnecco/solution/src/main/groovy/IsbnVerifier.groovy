class IsbnVerifier {
    static boolean isValid(String isbn) {

int total = 0;
int j= 10;
        //replace all hyphens in string
isbn = isbn.replaceAll('-','')
        //taking length of string without hyphens which should be 10 for valid ISBN
int length = isbn.length()
        //Index to check only last character can contain 'X' but not in middle of string
int ind = length -1;

if (isbn.contains('X'))
{
     ind =isbn.indexOf("X")
}
    //check with regex for any alphabets
boolean containsAlphabets = isbn.matches(".*[a-wA-Wy-zY-Z]+.*")

/*stop processing and return false if string contains alphabets, string length !=0 or if string contains 'X' in middle of string*/
if(containsAlphabets || length != 10 || ind != length-1) {
return false 
}
else{
    for (int i=0; i< length;i++){
        
      
         if(isbn[i].equals('X') && i == length-1)
        { 
            //X needs to be replaced with 10
            total+= 10*j;
        }
       
    else{
    total += isbn[i].toInteger()*j
    }
    j--;
}

return total%11 == 0 ? true: false
}
    }
}