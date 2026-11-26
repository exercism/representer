proc onEarth {ageInSec} { 
	set onE [expr { $ageInSec / (365.25 * 24.0 * 60.0 * 60.0) }]; 
	return $onE
}

proc onMercury {ageInSec} {
	return [expr {[onEarth $ageInSec] / 0.2408467}];
}

proc onVenus {ageInSec} {
	return [expr {[onEarth $ageInSec] / 0.61519726}];
}

proc onMars {ageInSec} {
	return [expr {[onEarth $ageInSec] / 1.8808158}];
}

proc onJupiter {ageInSec} {
	return [expr {[onEarth $ageInSec] / 11.862615}];
}

proc onSaturn {ageInSec} {
	return [expr {[onEarth $ageInSec] / 29.447498}];
}
proc onUranus {ageInSec} {
	return [expr {[onEarth $ageInSec] / 84.016846}];
}
proc onNeptune {ageInSec} {
	return [expr {[onEarth $ageInSec] / 164.79132}];
}

proc onSun {ageInSec} {
	error "not a planet";
}

# extra credit: generate the procedures programmatically
