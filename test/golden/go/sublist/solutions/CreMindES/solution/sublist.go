package sublist

// Relation type is defined in relations.go file.

func slicesEqual(l1, l2 []int) bool {
	if len(l1) != len(l2) {
		return false
	}

	if len(l1) == 0 && len(l2) == 0 {
		return true
	}

	equal := true
	if len(l1) == len(l2) {
		for i, entry := range l1 {
			if entry != l2[i] {
				equal = false
				break
			}
		}
	}

	return equal
}

func isSubList(l1, l2 []int) bool {
	for _, start := range GetAllIndex(l2, l1[0]) {
		for j, _ := range l1 {
			if l2[start+j] != l1[j] {
				break
			}
			if j == len(l1)-1 {
				return true
			}
		}
	}

	return false
}

func Sublist(l1, l2 []int) Relation {
	// TODO: use slices.Equal when go version is upgraded
	if slicesEqual(l1, l2) {
		return RelationEqual
	}

	if len(l1) == 0 {
		return RelationSublist
	}
	if len(l2) == 0 {
		return RelationSuperlist
	}

	if len(l1) < len(l2) {
		if isSubList(l1, l2) {
			return RelationSublist
		}
	}

	if len(l1) > len(l2) {
		if isSubList(l2, l1) {
			return RelationSuperlist
		}
	}

	return RelationUnequal
}

func GetAllIndex(list []int, entry int) []int {
	indexList := make([]int, 0)

	for i := 0; i < len(list); i++ {
		if list[i] == entry {
			indexList = append(indexList, i)
		}
	}

	return indexList
}
