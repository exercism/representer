class ScrabbleScore {
             
    static scoreWord(String word) {
        def val = ["aeioulnrst":1,
                   "dg"        :2,
                   "bcmp"      :3,
                   "fhvwy"     :4,
                   "k"         :5,
                   "jx"        :8,
                   "qz"        :10]
        word.tr('A-Z', 'a-z')
            .toList()
            .findResults{
                val.findResult { 
                    key,value -> 
                    if (key.contains(it)) value 
                    } 
                }
            .sum(0)
    }
}
