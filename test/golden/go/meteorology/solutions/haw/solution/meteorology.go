package meteorology

import "fmt"

type TemperatureUnit int

const (
	Celsius    TemperatureUnit = 0
	Fahrenheit TemperatureUnit = 1
)

// String method implement TemperatureUnit as Stringer interface
func (tu TemperatureUnit) String() string {
	units := []string{"°C", "°F"}

	return units[tu]
}

type Temperature struct {
	degree int
	unit   TemperatureUnit
}

// String method implement Temperature as Stringer interface
func (t Temperature) String() string {
	return fmt.Sprintf("%v %v", t.degree, t.unit)
}

type SpeedUnit int

const (
	KmPerHour    SpeedUnit = 0
	MilesPerHour SpeedUnit = 1
)

// String method implement SpeedUnit as Stringer interface
func (su SpeedUnit) String() string {
	units := []string{"km/h", "mph"}

	return units[su]
}

type Speed struct {
	magnitude int
	unit      SpeedUnit
}

// String method implement Speed as Stringer interface
func (s Speed) String() string {
	return fmt.Sprintf("%v %v", s.magnitude, s.unit)
}

type MeteorologyData struct {
	location      string
	temperature   Temperature
	windDirection string
	windSpeed     Speed
	humidity      int
}

// String method implement MeteorologyData as Stringer interface
func (md MeteorologyData) String() string {
	return fmt.Sprintf("%v: %v, Wind %v at %v, %v%% Humidity",
		md.location, md.temperature, md.windDirection, md.windSpeed, md.humidity)
}
