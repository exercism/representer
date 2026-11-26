// Package weather provides a method to output the weather condition in a particular location.
package weather

// CurrentCondition represents the current weather condition.
var CurrentCondition string

// CurrentLocation represents the location of the weather condition.
var CurrentLocation string

// Forecast provides a string representing the weather condition in a particular location.
func Forecast(city, condition string) string {
	CurrentLocation, CurrentCondition = city, condition
	return CurrentLocation + " - current weather condition: " + CurrentCondition
}
