package raindrops
import "core:fmt"

convert :: proc(n: int) -> string {
    return fmt.tprintf("%s%s%s%s", n%3==0?"Pling":"", n%5==0?"Plang":"", n%7==0?"Plong":"", (n%3>0 || n%5>0 && n%7>0)?fmt.tprintf("%d",n):"")
}

