package raindrops
import "strconv"

func Convert(number int) string {
	str := ""
    Pling(number,&str)
    Plang(number,&str)
    Plong(number,&str)
    if str ==""{
        str = strconv.Itoa(number)
    }
    return str
}
func Pling(number int, str *string) *string{
    if number%3 == 0{
    	*str += "Pling"
        }
    return str
}
func Plang (number int, str *string) *string{
    if number%5 == 0{
    	*str += "Plang"
        }
    return str
}
func Plong(number int, str *string) *string{
    if number%7 == 0{
    	*str += "Plong"
        }
    return str
}
