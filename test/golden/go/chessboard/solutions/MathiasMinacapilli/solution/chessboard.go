package chessboard

// Declare a type named File which stores if a square is occupied by a piece - this will be a slice of bools
type File []bool

// Declare a type named Chessboard which contains a map of eight Files, accessed with keys from "A" to "H"
type Chessboard map[string]File
/*
{
    "A": File{}, 
    "B": File{}, 
    "C": File{},
    "D": File{}, 
    "E": File{}, 
    "F": File{},
    "G": File{}, 
    "H": File{}, 
}
*/

// CountInFile returns how many squares are occupied in the chessboard,
// within the given file.
func CountInFile(cb Chessboard, file string) int {
    counter := 0
	for _, val := range cb[file] {
        if val {
            counter += 1
        }
    }
	return counter
}

func getFiles() []string {
	files := []string{"A", "B", "C", "D", "E", "F", "G", "H"}    
    return files
}

// CountInRank returns how many squares are occupied in the chessboard,
// within the given rank.
func CountInRank(cb Chessboard, rank int) int {
	if rank < 1 || rank > 8 {
        return 0
    }
	counter := 0
	for _, file := range getFiles() {
        if cb[file][rank-1] {
            counter += 1
        }
    }
	return counter
}

func getRanks() []int {
    return []int{1,2,3,4,5,6,7,8}
}

// CountAll should count how many squares are present in the chessboard.
func CountAll(cb Chessboard) int {
	counter := 0
    for _, file := range getFiles() {
        fileColumn, present := cb[file]
        if present {
            counter += len(fileColumn)
        }
    }
	return counter
}

// CountOccupied returns how many squares are occupied in the chessboard.
func CountOccupied(cb Chessboard) int {
	counter := 0
    for _, file := range getFiles() {
        counter += CountInFile(cb, file)
    }
	return counter
}
