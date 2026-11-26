class ScrabbleScore {
    static scoreWord(String word) {
        def score=0
        def ltr
        def myMap=[
            1:    ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' ],      
            2:    ['D', 'G' ] ,                              
            3:  ['B', 'C', 'M', 'P'] ,                        
            4:  ['F', 'H', 'V', 'W', 'Y'] ,                     
            5:    ['K'],                                  
            8:  ['J', 'X'] ,                             
            10: ['Q', 'Z']                               
        ]        
        if (word.size()==0){
			return 0
		}
        (0..<(word.size())).collect{
            myMap.each{k,v ->
                ltr=word[it].toUpperCase()
                if(v.find{it==ltr}){
                    score+=k.toInteger()
                }
            }        
        }
        return score
    }   
}
