object Hamming {
    def distance(left: String, right: String) = {
        if(left.length == right.length){
            Some(left.zip(right).map((t) => if(t._1 != t._2) 1 else 0).sum) 
        } else {
            None
        }
    }
}