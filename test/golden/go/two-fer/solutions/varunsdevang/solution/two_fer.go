
package twofer


func ShareWith(name string) string {
	s1:="One for "
	middle:="you"
	s2:=", one for me."
	if len(name) > 0 {
		middle=name
	}
	return s1+middle+s2
}
