// twofer is a package for the Two-fer exercise, contains
// a main file with the main function ShareWith and a testing file

package twofer

// ShareWith returns a string , if the name is empty it returns "One for you, one for me."
// If the name is not empty it returns "One for %name, one for me."
func ShareWith(name string) string {
	var person = name
	if name == "" {
		person = "you"
	}
	return ("One for " + person + ", one for me.")
}
