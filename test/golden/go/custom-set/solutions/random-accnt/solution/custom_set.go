package stringset

import ()

// Implement Set as a collection of unique string values.
//
// For Set.String, use '{' and '}', output elements as double-quoted strings
// safely escaped with Go syntax, and use a comma and a single space between
// elements. For example, a set with 2 elements, "a" and "b", should be formatted as {"a", "b"}.
// Format the empty set as {}.

// Define the Set type here.
type Set struct {
	items []string
}

func New() Set {
	return Set{}
}

func NewFromSlice(l []string) Set {
	set := New()
	for _, elem := range l {
		set.Add(elem)
	}

	return set
}

func (s Set) String() string {
	result := "{"

	if len(s.items) > 0 {
		unf := ""
		for i, elem := range s.items {
			unf += "\"" + elem + "\""
			if i < len(s.items)-1 {
				unf += ", "
			}
		}
		result += unf
	}

	result += "}"
	return result
}

func (s Set) IsEmpty() bool {
	return len(s.items) == 0
}

func (s Set) Has(elem string) bool {
	for _, e := range s.items {
		if e == elem {
			return true
		}
	}

	return false
}

func (s *Set) Add(elem string) {
	exists := false
	for _, e := range s.items {
		if e == elem {
			exists = true
			break
		}
	}

	if !exists {
		s.items = append(s.items, elem)
	}
}

func Subset(s1, s2 Set) bool {
	if len(s1.items) == 0 && len(s2.items) == 0 {
		return true
	}

	if len(s1.items) == 0 {
		return true
	}

	if len(s2.items) == 0 {
		return false
	}

	// s2 subset of s1
	if !s2.Has(s1.items[0]) {
		return false
	}

	for i, e2 := range s2.items {
		// found passible beginning
		if e2 == s1.items[0] {
			// does fit to set
			if len(s2.items[i:]) < len(s1.items) {
				return false
			}

			foundInvalid := false
			for ii, e1 := range s1.items {
				if e1 != s2.items[ii+i] {
					foundInvalid = true
					break
				}
			}
			if !foundInvalid {
				return true
			}
		}
	}

	return false
}

func Disjoint(s1, s2 Set) bool {
	if len(s1.items) > 0 && len(s2.items) == 0 {
		return true
	}

	for _, e1 := range s1.items {
		if s2.Has(e1) {
			return false
		}
	}

	return true
}

func Equal(s1, s2 Set) bool {
	if len(s1.items) == 0 && len(s2.items) == 0 {
		return true
	}

	if len(s1.items) != len(s2.items) {
		return false
	}

	for _, e1 := range s1.items {
		if !s2.Has(e1) {
			return false
		}
	}

	return true
}

func Intersection(s1, s2 Set) Set {
	set := New()
	for _, e1 := range s1.items {
		if s2.Has(e1) {
			set.Add(e1)
		}
	}

	return set
}

func Difference(s1, s2 Set) Set {
	diff := New()

	if len(s2.items) == 0 {
		return s1
	}

	for _, e1 := range s1.items {
		if s2.Has(e1) {
			continue
		}
		diff.Add(e1)
	}

	return diff
}

func Union(s1, s2 Set) Set {
	for _, e2 := range s2.items {
		s1.Add(e2)
	}

	return s1
}
