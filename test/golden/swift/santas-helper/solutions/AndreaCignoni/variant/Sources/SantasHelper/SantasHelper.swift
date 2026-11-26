func getName(_ item: (name: String, amount: Int)) -> String {
  return item.name
}

func createToy(name: String, amount: Int) -> (name: String, amount: Int) {
  return (name, amount)
}

func updateQuantity(_ items: [(name: String, amount: Int)], toy: String, amount: Int) ->  [(name: String, amount: Int)] {
  var updatedItems = items

  for i in 1..<updatedItems.count {
    if getName(updatedItems[i]) == toy {
      updatedItems[i].amount = amount
    }
  }
  return updatedItems
}

func addCategory(_ items: [(name: String, amount: Int)], category: String) -> [(name: String, amount: Int, category: String)] {
  var categorizedItems : [(name: String, amount: Int, category: String)] = []
  for item in items {
    let categorizedItem = (name: item.name, amount: item.amount, category: category)
    categorizedItems.append(categorizedItem)    
  }
  return categorizedItems
}
