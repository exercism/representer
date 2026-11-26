package bob

import "core:strings"
import "core:unicode"

Sure :: "Sure."
Chill :: "Whoa, chill out!"
Calm :: "Calm down, I know what I'm doing!"
Fine :: "Fine. Be that way!"
Whatever :: "Whatever."

response :: proc(input: string) -> string {
    input := strings.trim_space(input)
    is_question := strings.ends_with(input, "?")
    is_caps := !strings.contains_any(input, "abcdefghijklmnopqrstuvwxyz") && 
      strings.contains_any(input, "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    if len(input) == 0 {
        return Fine
    } else if is_question && is_caps {
        return Calm
    } else if is_question {
        return Sure
    } else if is_caps {
        return Chill
    } else {
        return Whatever
    }
}
