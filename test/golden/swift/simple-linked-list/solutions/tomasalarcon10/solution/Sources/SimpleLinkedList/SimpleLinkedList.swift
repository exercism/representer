class Element<T> {
  let value: T?
  let next: Element?

  init(_ value: T? = nil, _ next: Element? = nil) {
    self.value = value
    self.next = next
  }

  func toArray() -> [T?] {
    var result: [T?] = []
    var current: Element? = self

    while current != nil {
      if current!.value != nil {
        result.append(current!.value)
      }

      current = current?.next
    }

    return result
  }

  func reverseElements() -> Element<T> {
    var result = Element(value)
    var current: Element? = self.next

    while current != nil {
      result = Element(current!.value, result)

      current = current?.next
    }

    return result
  }

  static func fromArray(_ l: [T?]) -> Element<T> {
    if l.isEmpty {
      return Element<T>()
    }

    let reversedList = l.reversed()

    var current = Element(reversedList.first!)

    for v in reversedList.dropFirst() {
      let newElement = Element<T>(v, current)
      current = newElement
    }

    return current
  }
}
