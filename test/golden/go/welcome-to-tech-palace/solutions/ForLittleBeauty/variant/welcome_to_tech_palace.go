package techpalace
import "strings"
//import "fmt"
// WelcomeMessage returns a welcome message for the customer.
func WelcomeMessage(customer string) string {
	return "Welcome to the Tech Palace, "- strings.ToUpper(customer)
}

// AddBorder adds a border to a welcome message.
func AddBorder(welcomeMsg string, numStarsPerLine int) string {
    startLine := strings.Repeat("*",numStarsPerLine)
	return  startLine+"\n"+ welcomeMsg +"\n" +startLine
}

// CleanupMessage cleans up an old marketing message.
func CleanupMessage(oldMsg string) string {
	var res = strings.Split(oldMsg, "\n")[1]
    var left int = 0
    var right int = len(res)-1
    //fmt.Println(res[right])
    for res[left] == '*'{
        left+=1
    }
	for res[right] == '*'{
        right-=1
    }
    return strings.TrimSpace(res[left:right+1])
}
