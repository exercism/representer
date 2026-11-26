class ScrabbleScore {
    static score_map = ['k': 5]

    static scoreWord(String word) {
        if (! word )
            return 0

        if (score_map.size() == 1) {
            print 'doing stuff'
            'aeioulnrst'.each { score_map.putAt(it, 1) }
            'dg'.each { score_map.putAt(it, 2) }
            'bcmp'.each { score_map.putAt(it, 3) }
            'fhvwy'.each { score_map.putAt(it, 4) }
            'jx'.each { score_map.putAt(it, 8) }
            'qz'.each { score_map.putAt(it, 10) }
        }

        word.toLowerCase().toList().sum { score_map[it] }
    }

}
