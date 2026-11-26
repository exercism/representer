/* 
Package twofer implement a simple tutorial string program
*/
package twofer

// ShareWith returns a string the name of the input or 'you' if the name string is empty.
func ShareWith(name string) string {
    if "" == name {
        return ShareWith("you")
	}
	return "One for " + name + ", one for me."  // Sprintf could be used here as well
}
