extension String: Error {}

func compute(_ dnaSequence: String, against: String) throws -> Int? {
    guard dnaSequence.count == against.count else {
        throw "Error"
    }

    return zip(dnaSequence, against).filter { $0 != $1 }.count
}
