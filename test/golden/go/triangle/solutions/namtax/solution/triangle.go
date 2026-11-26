package triangle
// import "fmt"
type Kind string

const (
    NaT Kind = "NaT" 
    Equ Kind = "Equ" 
    Iso Kind = "Iso"
    Sca Kind = "Sca"
)

func KindFromSides(a, b, c float64) Kind {
	maps := map[int]Kind{1: Sca, 2: Iso, 3: Equ}
    dupes := Count(a,b,c)
    
    if (a + b <= c || b + c <= a || a + c <= b){ 
    	return NaT
    }
	return maps[dupes]
}

func Count(a,b,c float64) int{ 
    freq := map[float64]int{}
    sides := []float64{a,b,c}
    max := 0
    
    for _, v := range sides { 
    	freq[v]++
        if freq[v] > max { 
        	max = freq[v]
        }
    }

    return max
}