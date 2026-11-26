object SpaceAge {
  val earthYearSeconds = 31557600;
  val mercuryOrbitRatio = 0.2408467;
  val venusOrbitRatio = 0.61519726;
  val marsOrbitRatio = 1.8808158;
  val jupiterOrbitRatio = 11.862615;
  val saturnOrbitRatio = 29.447498;
  val uranusOrbitRatio = 84.016846;
  val neptuneOrbitRatio = 164.79132;

  def onEarth(age: Double): Double = age / earthYearSeconds;

  def onVenus(age: Double): Double = age / (earthYearSeconds * venusOrbitRatio)

  def onMercury(age: Double): Double = age / (earthYearSeconds * mercuryOrbitRatio)

  def onMars(age: Double): Double = age / (earthYearSeconds * marsOrbitRatio)

  def onJupiter(age: Double): Double = age / (earthYearSeconds * jupiterOrbitRatio)

  def onSaturn(age: Double): Double = age / (earthYearSeconds * saturnOrbitRatio)

  def onUranus(age: Double): Double = age / (earthYearSeconds * uranusOrbitRatio)

  def onNeptune(age: Double): Double = age / (earthYearSeconds * neptuneOrbitRatio)
}
