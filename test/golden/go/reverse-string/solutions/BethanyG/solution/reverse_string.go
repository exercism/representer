//Package reverse reverses a given string.
package reverse


//Reverse takes a string and returns a copy of the string in reverse order.
func Reverse(input string) string {
    reversed := []rune(input)
    for i, j := 0, len(reversed)-1; i<j; i, j = i+1, j-1 {
			reversed[i], reversed[j] = reversed[j], reversed[i]
		}

	return string(reversed)
}