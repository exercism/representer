object PerfectNumbers {
  def classify(num: Int): Either[String, NumberType.Value] = if(num <= 0) Left("Classification is only possible for natural numbers.")
  else (1 until num).filter(num % _ == 0).sum match {
    case sum if sum == num => Right(NumberType.Perfect)
    case sum if sum > num => Right(NumberType.Abundant)
    case _ => Right(NumberType.Deficient)
  }
}

object NumberType extends Enumeration {val Perfect, Abundant, Deficient: NumberType.Value = Value}
