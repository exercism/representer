// Package proverb returns proverb text for a list of inputs.
package proverb

import (
	"fmt"
)

// Proverb returns the proverb text for a list.
func Proverb(rhyme []string) []string {
	if len(rhyme) == 0 {
		return []string{}
	}
	result := []string{}
	for i := 1; i <= len(rhyme); i++ {
		result = append(result, fmt.Sprintf("For want of a %s the %s was lost.", rhyme[i-1], rhyme[i]))
	}
	result = append(result, fmt.Sprintf("And all for the want of a %s.", rhyme[0]))
	return result
}
