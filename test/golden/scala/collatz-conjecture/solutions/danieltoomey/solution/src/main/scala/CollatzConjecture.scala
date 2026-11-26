object CollatzConjecture {
  def steps(start:Int) : Option[Int] = {
    if (start < 1) {
      //println(s"ignoring ${start}")
      None
    }
    else {
      var count = 0
      var current = start
      while (current != 1) {
        if (current % 2 == 0) {
          current = current / 2
        }
        else {
          current = current * 3 + 1
        }
        count = count + 1
      }
      //println(s"went from ${start} to ${current} in ${count} steps")
      Some(count)
    }
  }
}