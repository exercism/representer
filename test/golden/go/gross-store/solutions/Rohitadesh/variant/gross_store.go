package gross
// import "fmt"
// Units stores the Gross Store unit measurements.
func Units() map[string]int {
	return map[string]int{
     	"quarter_of_a_dozen":3,
        "half_of_a_dozen":6,
        "dozen":12,
        "small_gross":120,
        "gross":144,
        "great_gross":1728,
        
    }
}

// NewBill creates a new bill.
func NewBill() map[string]int {
	customer:=map[string]int{}
	return customer
}


// AddItem adds an item to customer bill.
func AddItem(bill, units map[string]int, item, unit string) bool {
		u,ok := units[unit]
	if !ok {
		return false
	}
	bill[item] += u
	return true
}

// RemoveItem removes an item from customer bill.
func RemoveItem(bill, units map[string]int, item, unit string) bool {
 	unitVal,ok := units[unit]
	if !ok {
		return false
	}
	current,ok := bill[item]
    if !ok {
        return false
    }
	newVal := current - unitVal
    if newVal <= 0 {
        return false
    } else if newVal == 0 {
    	delete(bill, item)
    } else {
    	bill[item] = newVal
    }
	return true
}

// GetItem returns the quantity of an item that the customer has in his/her bill.
func GetItem(bill map[string]int, item string) (int, bool) {
	  b,ok := bill[item]
    if (!ok) {
        b = 0
    }
	return b, ok

}
