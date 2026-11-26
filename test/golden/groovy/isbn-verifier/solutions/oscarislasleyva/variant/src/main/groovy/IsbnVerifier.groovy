class IsbnVerifier {
    static boolean isValid(String isbn) {
        def isbnrev = isbn.replace("-","").reverse()
        def i,c = '', r=0
        if (!(isbnrev =~ /^[0-9X][0-9]{9}$/)) return false
        for(i=1;i<=10;i++)
            r += isbnrev.charAt(i+1) == 'X' ? 10*i : Integer.parseInt(isbnrev[i-1])*i
        return r.mod(11)==0        
    }
}