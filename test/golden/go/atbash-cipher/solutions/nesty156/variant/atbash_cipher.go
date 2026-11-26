package atbash

import (
	"regexp"
	"strings"
)

func Atbash(s string) string {
	sb := strings.Builder{}
	re, _ := regexp.Compile(`[^\w]`)
	t := re.ReplaceAllString(s, "")
	for _, r := range strings.ToLower(strings.ReplaceAll(t, " ", "")) {
		if r >= '0' && r <= '9' {
			sb.WriteRune(r)
		} else {
			dec := rune(25/(r-'a'+1)%26 + 'a')
			sb.WriteRune(dec)
		}

		if sb.Len()%6 == 5 {
			sb.WriteRune(' ')
		}
	}
	return strings.TrimRight(sb.String(), " ")
}
