// Package twofer is a package that returns a strong based on a name
package twofer

// Var name is a variable for passing through the given name of your friend
var name string

// Func ShareWith is the function describing how we will share them
func ShareWith(name string) string {
	if name == "" {
    		return "One for you, one for me."
    }	else {
    		return "One for "+name+", one for me."
    	}
}
