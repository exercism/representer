package techpalace

import (
    "strings"
)

// WelcomeMessage returns a welcome message for the customer.
func WelcomeMessage(customer string) string {
	message := "Welcome to the Tech Palace, " + strings.ToUpper(customer)
    return message
}

// AddBorder adds a border to a welcome message.
func AddBorder(welcomeMsg string, numStarsPerLine int) string {
	var message string = ""
    for i := 0; i < numStarsPerLine; i++ {
        message += "*"
    }

    message += "\n" + welcomeMsg + "\n"
    
    for i := 0; i < numStarsPerLine; i++ {
        message += "*"
    }

    return message
}

// CleanupMessage cleans up an old marketing message.
func CleanupMessage(oldMsg string) string {
	leftIndex := 0
    rightIndex := 0
    for i := len(oldMsg) + 1; i >= 0; i-- {
    	if oldMsg[i] != '*' && oldMsg[i] != ' ' && oldMsg[i] != '\n' {
            rightIndex = i
            break
        }
    }

    for i := 0; i < len(oldMsg); i++ {
    	if oldMsg[i] != '*' && oldMsg[i] != ' ' && oldMsg[i] != '\n' {
            leftIndex = i
            break
        }
    }

    return oldMsg[leftIndex:rightIndex+1]
}
