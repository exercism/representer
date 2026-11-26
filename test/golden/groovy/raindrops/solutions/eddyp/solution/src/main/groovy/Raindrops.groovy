class Raindrops {

    def convert(num) {
        // throw new UnsupportedOperationException('Method implementation is missing')
        def map = [ 3: "Pling", 5: "Plang", 7: "Plong" ]
        def r = ""

        for ( drop in map ) {
            if ( num % drop.key == 0 ) {
                r += drop.value
            }
        }

        return r == "" ? num.toString() : r
    }

}
