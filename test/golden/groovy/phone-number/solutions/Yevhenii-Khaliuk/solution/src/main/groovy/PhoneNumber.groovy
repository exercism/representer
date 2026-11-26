class PhoneNumber {

    static String clean(String input) {
        input = input.trim()
        def numberPattern = /^\+?1?[.( -]*?([2-9]\d{2})[.) -]*?([2-9]\d{2})[. -]*?(\d{4})$/

        if (!(input ==~ numberPattern)) {
            throw new IllegalArgumentException()
        }

        def matcher = input =~ numberPattern
        (1..3).collect { matcher[0][it] }.join('')
    }
}
