// Package cards returns card tricks
package cards

// FavoriteCards returns a slice with the cards 2, 6 and 9 in that order.
func FavoriteCards() []int {
	return []int{2, 6, 9}
	panic("Please implement the FavoriteCards function")
}

// GetItem retrieves an item from a slice at given position.
// If the index is out of range, we want it to return -1.
func GetItem(slice []int, index int) int {
	if len(slice) - 1 < index || index < 0 {
        return -1
    } else {
    	return slice[index]
    }
	panic("Please implement the GetItem function")
}

// SetItem writes an item to a slice at given position overwriting an existing value.
// If the index is out of range the value needs to be appended.
func SetItem(slice []int, index, value int) []int {
    newSlice := slice
    if len(slice) - 1 < index || index < 0 {
        newSlice = append(newSlice, value)
    } else {
		newSlice[index] = value
    }
	return newSlice
	panic("Please implement the SetItem function")
}

// PrependItems adds an arbitrary number of values at the front of a slice.
func PrependItems(slice []int, value ...int) []int {
    newSlice := value
	for _, val := range slice {
        newSlice = append(newSlice, val)
    }
	return newSlice
	panic("Please implement the PrependItems function")
}

// RemoveItem removes an item from a slice by modifying the existing slice.
func RemoveItem(slice []int, index int) []int {
    sliceLen := len(slice)
    if sliceLen - 1 < index || index < 0 {
        return slice
    } else {
    	return append (slice[:index], slice[index + 1:]...)
    }
	panic("Please implement the RemoveItem function")
}
