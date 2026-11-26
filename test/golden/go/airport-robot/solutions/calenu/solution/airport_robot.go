package airportrobot

type Greeter interface {
	LanguageName() string

	SayHello(name string) string
}

type Italian struct{}

func (i Italian) LanguageName() string {
	return "Italian"
}

func (i Italian) SayHello(name string) string {
	return "Ciao " + name + "!"
}

type Portuguese struct{}

func (p Portuguese) LanguageName() string {
	return "Portuguese"
}

func (p Portuguese) SayHello(name string) string {
	return "Olá " + name + "!"
}

func SayHello(name string, greeter Greeter) string {
	return "I can speak " + greeter.LanguageName() + ": " + greeter.SayHello(name)
}
