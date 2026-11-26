class Raindrops {

    def convert(num) {
        //throw new UnsupportedOperationException('Method implementation is missing')
	
String out = ""
        if(num % 3 == 0)
            out += "Pling"
        if(num % 5 == 0)
            out += "Plang"
        if(num % 7 == 0)
            out += "Plong"
        if(out == "")
            out = num.toString()
        //throw new UnsupportedOperationException('Method implementation is missing')
        return out
   
}

}
