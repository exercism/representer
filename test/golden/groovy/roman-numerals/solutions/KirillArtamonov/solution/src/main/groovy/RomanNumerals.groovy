class RomanNumerals {
    RomanNumerals() {
        Integer.metaClass.getRoman = { ->
            convert(delegate as int, '')
        }
    }

    static final MAPPING = [1000: 'M',
                            900 : 'CM',
                            500 : 'D',
                            400 : 'CD',
                            100 : 'C',
                            90  : 'XC',
                            50  : 'L',
                            40  : 'XL',
                            10  : 'X',
                            9   : 'IX',
                            5   : 'V',
                            4   : 'IV',
                            1   : 'I']

    static convert(int n, String acc) {
        def e = MAPPING.find { n >= it.key }
        n > 0 ? convert(n - e.key, acc + e.value) : acc
    }
}
