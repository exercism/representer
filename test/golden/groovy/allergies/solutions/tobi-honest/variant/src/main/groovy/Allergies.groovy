class Allergies {
    Integer score

    Allergies(Integer score) {
        this.score = score
    }

    boolean allergicTo(String substance){
        def aList = this.list()
        return aList.contains(substance)
    }

    List<Integer> list(){
        List<Integer> algs = [0]
        Integer score1 = this.score
        while(score1 > 0){
            Integer count = 0
            Integer sum = algs.sum()
            Integer score2 = this.score - sum
            while(true){
                if(score2 % 2 != 0){
                    score2 /= 2
                    count += 1
                } else{
                    Integer minus = 2**count
                    algs.add(minus)
                    score1 -= (minus)
                    break
                }
            }
        }
        algs = algs.findAll{it<129 && it >0}
        Map mp = [1: "eggs", 2: "peanuts", 4: "shellfish", 8:"strawberries", 16:"tomatoes", 32: "chocolate", 64: "pollen", 128:"cats"]
        for(int i= 0; i<algs.size(); i++){
            if(mp.containsKey(algs[i])){
                algs[i] = mp.get(algs[i])
            }    
        }  
        return algs
    }
}