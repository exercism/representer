class Pangram {

    static boolean isPangram ( String sentence ) {
        ( 'a'..'z' ).every {
            sentence.toLowerCase ().contains ( it )
        }
    }

}