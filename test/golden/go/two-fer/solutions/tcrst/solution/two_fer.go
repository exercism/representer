// This is a "stub" file.  It's a little start on your solution.
// It's not a complete solution though; you have to write some code.

// Package twofer should have a package comment that summarizes what it's about.
// https://golang.org/doc/effective_go.html#commentary
package twofer

import (
)

// ShareWith should have a comment documenting it.
func ShareWith(name string) string {
	    var twoFer string
        switch name {
		case "Alice":
			twoFer = "One for Alice, one for me."
		case "Bob":
			twoFer = "One for Bob, one for me."
		default:
			twoFer = "One for you, one for me."

		}
		return twoFer
}
