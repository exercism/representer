object Hamming {
    def distance(a: String, b: String) : Option[Int] = {      
        if (a.size != b.size){
            None
        }else{
            Some(a.zip(b).filter(x => x._1 != x._2).size)
        }
    }
}