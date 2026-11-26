package gross

// Units stores the Gross Store unit measurements.
func Units() map[string]int {
	return map[string]int{
        "quarter_of_a_dozen": 3,
        "half_of_a_dozen": 6,
        "dozen": 12,
        "small_gross": 120,
        "gross": 144,
        "great_gross": 1728,
    }
}

// NewBill creates a new bill.
func NewBill() map[string]int {
	return map[string]int{}
}

// AddItem adds an item to customer bill.
func AddItem(bill, units map[string]int, item, unit string) bool {
	q, existing := units[unit]
    if !existing {
        return false
    }
	bill[item]+= q
    return true
}

// RemoveItem removes an item from customer bill.
func RemoveItem(bill, units map[string]int, item, unit string) bool {
	_, existing := bill[item]
    if !existing{
        return false
    }
	q, existing := units[unit]
    if !existing{
        return false
    }
	q = bill[item]-q
    if q<0{
        return false
    } else if q == 0{
    	delete(bill, item)
        return true
    }
	bill[item] = q
	return true
}

// GetItem returns the quantity of an item that the customer has in his/her bill.
func GetItem(bill map[string]int, item string) (int, bool) {
	q, existing := bill[item]
    if !existing{
        return 0, false
    }
	return q, true
}
