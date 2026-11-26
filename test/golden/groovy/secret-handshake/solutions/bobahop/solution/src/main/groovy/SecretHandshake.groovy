class SecretHandshake {

    private final static SIGNS = ['wink', 'double blink', 'close your eyes', 'jump']
    private final static REVERSE_SIGNS = 16
    
    static List<String> commands(int number) {
        def signs = (0..3).inject([]) { list, index -> {
                if (1 << index & number) list.add(SIGNS[index])
                list
            }
        }
        number & REVERSE_SIGNS ? signs.reverse() : signs
    }
}
