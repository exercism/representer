package airportrobot

import "fmt"

// Greeter is an interface for greeting in different languages.
type Greeter interface {
	LanguageName() string
	Greet(name string) string
}

// Italian implements Greeter for the Italian language.
type Italian struct{}

// LanguageName returns the name of the language.
func (i Italian) LanguageName() string {
	return "Italian"
}

// Greet returns a greeting in Italian.
func (i Italian) Greet(name string) string {
	return fmt.Sprintf("Ciao %s!", name)
}

// Portuguese implements Greeter for the Portuguese language.
type Portuguese struct{}

// LanguageName returns the name of the language.
func (p Portuguese) LanguageName() string {
	return "Portuguese"
}

// Greet returns a greeting in Portuguese.
func (p Portuguese) Greet(name string) string {
	return fmt.Sprintf("Olá %s!", name)
}

// SayHello greets the provided name using the specified Greeter.
func SayHello(name string, g Greeter) string {
	return fmt.Sprintf("I can speak %s: %s", g.LanguageName(), g.Greet(name))
}
