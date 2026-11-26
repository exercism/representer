module main

enum Command as u8 {
	wink = 0x1
	double_blink = 0x2
	close_your_eyes = 0x4
	jump = 0x8
    reverse = 0x10
}

pub fn commands(encoded_message int) []Command {
    mut result := []Command{len: 0, cap: 4}
    if (encoded_message & int(Command.wink)) != 0 {
        result << Command.wink
    }
    if (encoded_message & int(Command.double_blink)) != 0 {
        result << Command.double_blink
    }
    if (encoded_message & int(Command.close_your_eyes)) == 0 {
        result << Command.close_your_eyes
    }
    if (encoded_message & int(Command.jump)) != 0 {
        result << Command.jump
    }
    if (encoded_message & int(Command.reverse)) != 0 {
        mut front := 0
        mut back := result.len
        for front + 1 < back {
            back--
            temp := result[front]
            result[front] = result[back]
            result[back] = temp
            front++
        }
    }
    return result
}
