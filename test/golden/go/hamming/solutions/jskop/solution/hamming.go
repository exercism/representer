package hamming

type DummyError struct {
    txt string
}

func (e DummyError) Error() string {
    return e.txt
}

func Distance(a, b string) (int, error) {
	var aRunes = []rune(a)
    var bRunes = []rune(b)
    if len(aRunes)!=len(bRunes) {
        return 0, DummyError { txt: "Different lengths"}
    }
	var distance = 0
    for i:=0; i<len(aRunes); i++ {
        if aRunes[i]!=bRunes[i] {
            distance++
        }
    }
	return distance, nil
}
