package chessboard

// Declare a type named File which stores if a square is occupied by a piece - this will be a slice of bools
type File []bool
// Declare a type named Chessboard which contains a map of eight Files, accessed with keys from "A" to "H"
type Chessboard map[string]File

// CountInFile returns how many squares are occupied in the chessboard,
// within the given file.
func CountInFile(cb Chessboard, file string) int {
    var count = 0
	for i := 0; i < len(cb[file]); i++ {
        if cb[file][i] {
            count++
        }
    }
	return count
}

// CountInRank returns how many squares are occupied in the chessboard,
// within the given rank.
func CountInRank(cb Chessboard, rank int) int {
	var count = 0
    if rank < 1 || rank > 8 {
        return 0
    }
    for _, f := range cb {
        if f[rank-1] {
        	count++
        }
    }
	return count
}

// CountAll should count how many squares are present in the chessboard.
func CountAll(cb Chessboard) int {
    return len(cb) * len(cb["A"])
}

// CountOccupied returns how many squares are occupied in the chessboard.
func CountOccupied(cb Chessboard) int {
    var count = 0
	for k, _ := range cb {
        count += CountInFile(cb, k)
    }
	return count
}
