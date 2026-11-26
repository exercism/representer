// This package contains function ShareWith that tells who is your friend
package twofer

/*
ShareWith function tells who is your friend
If there is no name it is the person sitting next to you
*/

func ShareWith(name string) string {
	youFriend := "One for you, one for me."
	nameFriend := "One for " + name + ", one for me."


	if name == "" {
		return youFriend
	} else {
		return nameFriend
	}

}
