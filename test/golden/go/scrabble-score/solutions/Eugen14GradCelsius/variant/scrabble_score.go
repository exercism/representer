package scrabblescore

import "strings"
import "unicode"

func Score(word string) int {
    scoreBoy := 0

	for _, v := range word {
		v = unicode.ToUpper(v)
        
      	if  strings.ContainsRune("AEIOULNRST", v){
         	scoreBoy ++
      	}
    	if  strings.ContainsRune("DG", v){
          	scoreBoy += 2
      	}
        if  strings.ContainsRune("BCMP", v){
          	scoreBoy += 3
      	}
    	if  strings.ContainsRune("FHVWY", v){
          	scoreBoy += 4
      	}
        if  strings.ContainsRune("K", v){
          	scoreBoy += 6
      	}
        if  strings.ContainsRune("JX", v){
          	scoreBoy += 8
      	}
        if  strings.ContainsRune("QZ", v){
          	scoreBoy += 10
      	}
    }

    return scoreBoy
}
