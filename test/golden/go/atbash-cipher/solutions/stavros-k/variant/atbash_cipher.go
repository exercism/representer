package atbash

import (
    "strings"
    "unicode"
)

func Atbash(s string) string {
	var c strings.Builder
	printables := 0
    lastPrintable := 0
    sLen := len(s)
    for idx, char := range s {
        // Every 5 printed chars, add a space, but don't repeat spaces 
        // unless there are 5 more printed chars. Also don't finish with a space
        if printables % 5 == 0 || lastPrintable != printables && idx+1 != sLen {
            lastPrintable = printables
            c.WriteRune(' ')
        }
    	switch {
            case unicode.IsDigit(char):
                printables++
                c.WriteRune(char)
            case unicode.IsLetter(char):
                printables++
                char = unicode.ToLower(char)
                cIdx := char - 'a'
                c.WriteRune('z' - cIdx)
        }
    }
	return c.String()
}
