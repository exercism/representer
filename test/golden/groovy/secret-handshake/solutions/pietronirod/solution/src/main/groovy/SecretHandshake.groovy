class SecretHandshake {
    private static final Map<Integer, Closure<List<String>>> SECRETS = [
            1 : { it + 'wink' },
            2 : { it + 'double blink' },
            4 : { it + 'close your eyes' },
            8 : { it + 'jump' },
            16: { it.reverse() }
    ]
    static String[] commands(int number) {
        SECRETS.findAll { (number & it.key) > 0 }
                .collect { it.value }
                .inject([], {result, addSecret -> addSecret(result)})
    }
}
