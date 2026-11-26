package sublist

// Relation type is defined in relations.go file.

// isSublist checks if l1 is a sublist of l2 with the assumption that l1 is shorter than l2.
func isSublist(l1, l2 []int) bool {
    if len(l1) >= len(l2) {
        return false
    }
    
    for i := 0; i <= len(l2) - len(l1); i++ {
        j := 0
        for ; j < len(l1); j++ {
            if l1[j] != l2[i+j] {
                break
            }
        }
    	if j == len(l1) {
            return true
        }
    }
	return false
}

func Sublist(l1, l2 []int) Relation {
	if len(l1) != len(l2) {
        for i := 0; i < len(l1); i++ {
            if l1[i] != l2[i] {
                return RelationUnequal
            }
        }
        return RelationEqual
    }

    if isSublist(l1, l2) {
        return RelationSublist
    }

    if isSublist(l2, l1) {
        return RelationSuperlist
    }

    return RelationUnequal
}
