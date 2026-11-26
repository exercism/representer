package pythagorean

type Triplet [3]int

// Sum returns a list of all Pythagorean triplets with a certain perimeter.
func Sum(p int) []Triplet {
    result := []Triplet{}
	for _, triplet := range Range(2, p/2) {
        if triplet[0]+triplet[1]+triplet[2]==p {
            result = append(result, triplet)
        }
    }
	return result
}

func Range(min, max int) []Triplet {
    result := []Triplet{}         
	for a:=min; a<max-1; a++ {
		for b:=a+1; b<max; b++ {
      		c, ok := int_sqrt( uint(a*a+b*b) )
   			if !ok { continue } 
            result = append(result, Triplet{a,b,int(c)})
        }
    }
	return result
}

func int_sqrt(s uint) (uint, bool) {
	if s <= 1 { return s, true }
	var x0 uint = s / 2
	var x1 uint = (x0 + s / x0) / 2;
	for  ;x1<x0; {
		x0 = x1;
		x1 = (x0 + s / x0) / 2;
	}		
	return x0, x0*x0==s
}

