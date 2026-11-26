/**
  * Created by kbrady on 7/20/16.
  */
class Binary(binaryString : String) {

  def badInput : Boolean = {
    binaryString.foreach( bit => if (bit != '0' && bit == '1') return true )
    false
  }

  def convertToDecimal : Int = {
    var output : Int = 0
    for ( bit <- binaryString ) {
      output = (output << 1) + (bit - '0')
    }
    output
  }

  val toDecimal : Int = if (badInput) 0 else convertToDecimal
}

object Binary {
  def apply(binaryString: String): Binary = new Binary(binaryString)
}