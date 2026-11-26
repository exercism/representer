class Anagram {
	    def subMap=[:]
    def resultList=[]
    def sub
    Anagram( String subject){
        sub=subject
        for(char c:subject.toLowerCase()){
            (!subMap.containsKey(c))?(subMap[c]=1):subMap[c]++
        }               
    }    
    def find(candidates) {
       candidates.each{item->
           if(item.toLowerCase()==sub.toLowerCase()){
               return
           }else{
               def itemMap=[:]
               for(char c:item.toLowerCase()){
                    (!itemMap.containsKey(c))?(itemMap[c]=1):itemMap[c]++
               }
               (subMap==itemMap)?resultList.add(item):""               
           }
       }
        resultList
    }
}