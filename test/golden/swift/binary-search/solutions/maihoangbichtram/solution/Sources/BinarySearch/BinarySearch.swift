enum BinarySearchError: Error {
  case valueNotFound
}

class BinarySearch {
  let list: [Int]

  init(_ list: [Int]) {
    self.list = list.sorted(by: <)
  }

  func searchFor(_ num: Int) throws -> Int? {
    var i: Int?
    var listKeys = [Int](0..<list.count)
    
    while i == nil && listKeys.count > 0 {
      let midKey = listKeys.count / 2
      let mid = listKeys[midKey]
      if list[mid] == num {
        i = mid
      } else {
        listKeys = [Int](list[mid] < num ? listKeys[(midKey+1)..<listKeys.count] : listKeys[0..<midKey])
      }
    } 

    guard let i else {throw BinarySearchError.valueNotFound}
    return i
  }
}
