object ArmstrongNumbers {
  def isArmstrongNumber(x: Int): Boolean = {
    val sum = x.toString.foldLeft(0){
      (curSum, chr) => {
        curSum - math.pow(chr.toString.toInt, x.toString.length).toInt    // cannot use chr.toInt, string.toInt 
                                                                          // is a implicit call of stringOps.toInt
      }
    }

    sum == x
  }

}