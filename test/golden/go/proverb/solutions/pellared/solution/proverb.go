// Package proverb contains function which returns list of proverbs
package proverb

import "fmt"

// Proverb returns slice of proverb sentences
func Proverb(rhyme []string) []string {
	result := []string{}
	if len(rhyme) == 0 {
		return result
	}
	for i := 0; i < len(rhyme)-1; i++ {
		result = append(result, fmt.Sprintf("For want of a %s the %s was lost.", rhyme[i], rhyme[i+1]))
	}
	result = append(result, fmt.Sprintf("And all for the want of a %s.", rhyme[0]))
	return result
}
