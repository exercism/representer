/*
	Package twofer implements the expression two for one. ("One for you and one for me")
*/
package twofer

const DEFAULT_NAME = "you"
const PHRASE_PREFIX = "One for "
const PHRASE_SUFFIX = ", one for me."

// ShareWith function implements TwoFer, receiving person name as parameter.
// PS: when no name is given, it returns "you" instead of person name.
func ShareWith(name string) string {
	if name == "" {
		return PHRASE_PREFIX + DEFAULT_NAME + PHRASE_SUFFIX
	}
	return PHRASE_PREFIX + name + PHRASE_SUFFIX
}
