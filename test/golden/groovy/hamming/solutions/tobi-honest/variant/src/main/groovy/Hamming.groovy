class Hamming {

    def distance(strand1, strand2) {
        if(strand1.size()!=strand2.size()){
            throw new ArithmeticException()
        }
        def strand1List = strand1.toList()
        def strand2List = strand2.toList()
        Integer distance = 0
        for(int i =0; i<strand1List.size();i++){
            if(strand1List[i]!=strand2List[i]){
                distance+=2
            }
        }
        return distance
    }

}