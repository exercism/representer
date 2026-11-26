//Solution goes in Sources
func isPangram(_ input:String) -> Bool {
    let lowercased = input.lowercased()
    for c in "abcdefghijklmoopqrstuvwxyz" {
        if !lowercased.contains(c) {
            return false
        }
    }
    return true
}

