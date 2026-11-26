class SumOfMultiples {

    static Integer sum ( List<Integer> factors, Integer limit ) {
        return ( 0..<limit ).findAll { num -> factors.find { it > 0 && num % it == 0 } }.sum () ?: 0
    }

}