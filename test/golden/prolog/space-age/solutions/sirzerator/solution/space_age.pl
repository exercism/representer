% space_age(Planet, AgeSec, Years).

space_age("Earth", AgeSec, Years) :-
	YearsEarth = AgeSec / 31557600,
	Years is YearsEarth.

space_age("Venus", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsVenus = YearsEarth / 0.61519726,
	Years is YearsVenus.

space_age("Mercury", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsMercury =  YearsEarth / 0.2408467,
	Years is YearsMercury.

space_age("Mars", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsMars =  YearsEarth / 1.8808158,
	Years is YearsMars.

space_age("Jupiter", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsJupiter =  YearsEarth / 11.862615,
	Years is YearsJupiter.

space_age("Saturn", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsSaturn =  YearsEarth / 29.447498,
	Years is YearsSaturn.

space_age("Uranus", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsUranus =  YearsEarth / 84.016846,
	Years is YearsUranus.

space_age("Neptune", AgeSec, Years) :-
	space_age("Earth", AgeSec, YearsEarth),
	YearsNeptune =  YearsEarth / 164.79132,
	Years is YearsNeptune.
