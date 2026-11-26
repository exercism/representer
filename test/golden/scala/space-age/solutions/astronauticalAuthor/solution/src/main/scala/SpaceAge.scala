object SpaceAge {
	private def earthSecondsInAYear = 31557600

	def onEarth(age: Double): Double = {
		ageOnPlanet(age, 1)
	}

	def onMercury(age: Double): Double = {
		val mercuryToEarthYears : Double = .2408467
		(math rint ageOnPlanet(age, mercuryToEarthYears) * 100) / 100
	}

	def onVenus(age: Double): Double = {
		val venusToEarthYears : Double = .61519726
		ageOnPlanet(age, venusToEarthYears)
	}

	def onMars(age: Double): Double = {
		val marsToEarthYears : Double = 1.8808158
		ageOnPlanet(age, marsToEarthYears)
	}

	def onJupiter(age: Double): Double = {
		val jupiterToEarthYears : Double = 11.862615
		ageOnPlanet(age, jupiterToEarthYears)
	}

	def onSaturn(age: Double): Double = {
		val saturnToEarthYears : Double = 29.447498
		ageOnPlanet(age, saturnToEarthYears)
	}

	def onUranus(age: Double): Double = {
		val uranusToEarthYears : Double = 84.016846
		ageOnPlanet(age, uranusToEarthYears)
	}

	def onNeptune(age: Double): Double = {
		val neptuneToEarthYears : Double = 164.79132
		ageOnPlanet(age, neptuneToEarthYears)
	}

	private def ageOnPlanet(age: Double, planetToEarthYears: Double): Double = {
		val unroundedAge : Double = age / (earthSecondsInAYear * planetToEarthYears)
		BigDecimal(unroundedAge).setScale(2, BigDecimal.RoundingMode.HALF_UP).toDouble
	}
}