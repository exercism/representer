class ETL {

    static transform(input) {
        def output = [:]
        input.each { score, letters ->
            letters.each { letter ->
                output[letter.toUpperCase()] = score as int
            }
        }
        return output
    }
}