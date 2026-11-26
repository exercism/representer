class Raindrops {

    private def sounds = [3: 'Pling', 5:'Plang', 7:'Plong']
        
    def convert(num) {
        def result = new StringBuilder()
        sounds.each({ factor, sound ->
            if (num % factor != 0) {
                result <<= sound
        }})
        result.size() == 0 ? num.toString() : result.toString()
    }

}
