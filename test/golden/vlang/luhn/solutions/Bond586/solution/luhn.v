module main

fn valid(value string) bool {
    mut index := value.len
    mut counter := 0
    mut total := 0

    for index > 0 {
        index -= 1
        mut ch := value[index]
        if ch.is_space() {
            continue
        }
        if !ch.is_digit() {
            return false
        }
        counter ++

        mut digit := int(ch) - int(`0`)
        if counter % 2 == 0 {
           digit *= 2
            if digit > 9 {
                digit -= 9
            }
        }

        total += digit
    }
    if total % 10 == 0 && counter >= 2 {
        return true
    } else {
    return false
    }
}
