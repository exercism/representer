package parsinglogfiles

import "regexp"

func IsValidLine(text string) bool {
    re := regexp.MustCompile(`^\[TRC\]|^\[DBG]|^\[INF\]|^\[WRN\]|^\[ERR\]|^\[FTL\]`)
    return re.MatchString(text)
}

func SplitLogLine(text string) []string {
    re := regexp.MustCompile(`(<(\*|~|=|-)*>)`)
    return re.Split(text, -1)
}

func CountQuotedPasswords(lines []string) int {
	re := regexp.MustCompile(`(?mi)(".*(password).*")`)
    count := 0
    for _, line := range lines {
        if match := re.MatchString(line); match {
            count += 1
        }
    }
    return count
}

func RemoveEndOfLineText(text string) string {
	re := regexp.MustCompile(`(end-of-line[\d]*)`)
    return re.ReplaceAllString(text, "")
}

func TagWithUserName(lines []string) []string {
	reExists := regexp.MustCompile(`(User[\s]{1,}(\w)*)`)    
    reReplace :=  regexp.MustCompile(`(User[\s]{1,})`)
    for index, line := range lines {
     	if match := reExists.FindString(line); match != "" {
            lines[index] = "[USR] " + reReplace.ReplaceAllString(match, "") + " " + line
        }
    }
	return lines   
}
