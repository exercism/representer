
extension Array {
    
    func keep(_ f: (Element) -> Bool) -> [Element] {
        var kept = [Element]()
        self.forEach { if f($0) { kept.append($0) } }
        return kept
    }
    
    func discard(_ f: (Element) -> Bool) -> [Element] {
        return self.keep { !f($0) }
    }
}
