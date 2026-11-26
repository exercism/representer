
case class Triangle(s1: Double, s2: Double, s3: Double) {

  val soredListOfSections = Seq(s1,s2,s3).sorted
  val lengthOfDistinctSections = soredListOfSections.distinct.length

  def checkInequality(sortedList: Seq[Double]): Boolean = sortedList(0) + sortedList(1) >= sortedList(2) && !sortedList.contains(0)

  def equilateral: Boolean = checkInequality(soredListOfSections) && lengthOfDistinctSections == 1
  def isosceles: Boolean = checkInequality(soredListOfSections) && (lengthOfDistinctSections == 2 || lengthOfDistinctSections == 1)
  def scalene: Boolean = checkInequality(soredListOfSections) && lengthOfDistinctSections == 3
}
