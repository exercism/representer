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
	unit_value, exists := units[unit]
    if !exists {
        return false
    }

    item_amount, _ := bill[item]
    bill[item] = item_amount + unit_value
    return true
}

// RemoveItem removes an item from customer bill.
func RemoveItem(bill, units map[string]int, item, unit string) bool {
	item_amount, item_exists := bill[item]
    unit_value, unit_exists := units[unit]
    new_amount := item_amount - unit_value
    
    if !item_exists || !unit_exists || new_amount < 0 {
        return false
    }   

    if 0 == new_amount {
        delete(bill, item)
    } else {
    	bill[item] = new_amount
    }
    
    return true
}

// GetItem returns the quantity of an item that the customer has in his/her bill.
func GetItem(bill map[string]int, item string) (int, bool) {
	value, exists := bill[item]

    return value, exists
}
