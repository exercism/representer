object Twofer {
  //I would have used a default option for the constructor parm of you
  def twofer(name: String = "you"): String = {
    s"One for $name, one for me."
  }
}
