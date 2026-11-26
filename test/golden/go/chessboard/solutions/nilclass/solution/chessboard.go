package chessboard

// Declare a type named File which stores if a square is occupied by a piece - this will be a slice of bools
type File []bool

// Declare a type named Chessboard which contains a map of eight Files, accessed with keys from "A" to "H"
type Chessboard map[string]File

// CountInFile returns how many squares are occupied in the chessboard,
// within the given file.
func CountInFile(cb Chessboard, file string) (count int) {
    fields, ok := cb[file]
    if ok {
    	for _, occupied := range fields {
        	if occupied {
        		count += 1
        	}
    	}
    }
	return
}

// CountInRank returns how many squares are occupied in the chessboard,
// within the given rank.
func CountInRank(cb Chessboard, rank int) (count int) {
	if rank > 0 && rank <= 8 {
        for _, file := range cb {
            if file[rank - 1] {
                count += 1
            }
        }
    }
	return
}

// CountAll should count how many squares are present in the chessboard.
func CountAll(cb Chessboard) (count int) {
	for _, file := range cb {
        count += len(file)
    }
	return
}

// CountOccupied returns how many squares are occupied in the chessboard.
func CountOccupied(cb Chessboard) (count int) {
	for file := range cb {
        count += CountInFile(cb, file)
    }
	return
}
