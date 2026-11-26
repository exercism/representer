package chessboard

// Declare a type named File which stores if a square is occupied by a piece - this will be a slice of bools
type File []bool
// Declare a type named Chessboard which contains a map of eight Files, accessed with keys from "A" to "H"
type Chessboard map[string]File 
// CountInFile returns how many squares are occupied in the chessboard,
// within the given file.
func CountInFile(cb Chessboard, file string) int {
    l_num :=0
	for _,x := range cb [file] {
            if x {l_num++}
            
    }
  return l_num
}

// CountInRank returns how many squares are occupied in the chessboard,
// within the given rank.
func CountInRank(cb Chessboard, rank int) int {
		l_num := 0
	if rank > 0 && rank < 9 {
		for _, x := range cb {
			if x[rank-1] {
				l_num++
			}
		}
	}
	return l_num
}

// CountAll should count how many squares are present in the chessboard.
func CountAll(cb Chessboard) int {
		l_num := 0
	for _, x := range cb {
		l_num += len(x)
	}
	return l_num

}

// CountOccupied returns how many squares are occupied in the chessboard.
func CountOccupied(cb Chessboard) int {
		l_num := 0
	for _, x := range cb {
		for _, y := range x {
			if y {
				l_num++
			}
		}
	}
	return l_num
}
