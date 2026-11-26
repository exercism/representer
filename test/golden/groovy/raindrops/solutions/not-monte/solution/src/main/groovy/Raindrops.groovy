class Raindrops {

    def convert(num) {
        //throw new UnsupportedOperationException('Method implementation is missing')
        String sound = ""
        if (num % 3 == 0)
            sound += "Pling"
        if (num % 5 == 0)
            sound += "Plang"
        if (num % 7 == 0)
            sound += "Plong"
        if (sound == "")
            sound += num.toString()
            
        return sound
    }

}
