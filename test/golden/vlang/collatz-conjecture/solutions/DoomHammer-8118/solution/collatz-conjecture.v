module main

fn collatz(number int) !int {
    if number < 1 {
        return error("Number should be positive")
    }
    mut seq := 0
    mut num := number
    for {
    	if num <= 1 {
    		break
    	}
    	seq += 1
        if num % 2 == 0
        {
            num = num / 2
        } else {
            num = 3 * num + 1
        }
    }
    return seq
}
