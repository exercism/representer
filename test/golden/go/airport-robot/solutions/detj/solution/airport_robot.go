package airportrobot

import "fmt"

// Greeter provides the robot's greeting
// behaviors.
type Greeter interface {
	// LanguageName returns the language
	// the robot will greet in.
	LanguageName() string

	// Greet greets the visitor in their
	// language.
	Greet(visitor string) string
}

// SayHello says hello to the visitor
// in their language.
func SayHello(visitor string, greeter Greeter) string {
	return fmt.Sprintf("I can speak %s: %s", greeter.LanguageName(), greeter.Greet(visitor))
}

// Italian represents an Italian
// visitor.
type Italian struct{}

// LanguageName returns the Italian language.
func (i Italian) LanguageName() string {
	return "Italian"
}

// Greet greets the visitor in Italian language.
func (i Italian) Greet(visitor string) string {
	return fmt.Sprintf("Ciao %s!", visitor)
}

// Portuguese represents a Portuguese
// visitor.
type Portuguese struct{}

// LanguageName returns the Portuguese language.
func (p Portuguese) LanguageName() string {
	return "Portuguese"
}

// Greet greets the visitor in Portuguese language.
func (p Portuguese) Greet(visitor string) string {
	return fmt.Sprintf("Olá %s!", visitor)
}
