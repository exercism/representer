class RunLengthEncoding {
    static String encode(String input) {
                input.replaceAll('(.)\\1+') {"${it[0].length()}${it[1]}"}
    }
    static String decode(String input) {
                input.replaceAll('(\\d+)(.)') {it[2] * (it[1] as int)}
    }

}