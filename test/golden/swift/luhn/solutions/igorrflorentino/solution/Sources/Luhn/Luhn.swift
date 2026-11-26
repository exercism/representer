import Foundation

func isValidLuhn(_ number: String) -> Bool {
	let pattern = "^[0-9\\s]*$"
	let regex = try! NSRegularExpression(pattern: pattern)
	let range = NSRange(location: 0, length: number.utf16.count)
	let isValid = regex.firstMatch(in: number, options: [], range: range) != nil
	
	guard isValid == true else { return false }
	
	let digits = Array(number.filter { $0.isNumber }).compactMap { Int(String($0)) }
	print(digits)
	
	guard digits.count > 1 else { return false }
	
	let doubled = digits.reversed().enumerated().map { index, value in
		if index % 2 == 1 {
			let double = value * 2
			return double > 9 ? (double - 9) : (double)
		} else{
			return value
		}
	}.reversed()
	
	print(Array(doubled))
	print(doubled.reduce(0, +))
	return doubled.reduce(0, +) % 10 == 0
}
