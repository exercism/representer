let itemsDict = ["eggs": 1, "peanuts": 2, "shellfish": 4, "strawberries": 8, "tomatoes": 16, "chocolate": 32, "pollen": 64, "cats": 128]

class Allergies {
    let allergiesPoints: Int
    
    init(_ allergiesPoints: Int) {
        self.allergiesPoints = allergiesPoints > 256 ? allergiesPoints - 256 : allergiesPoints
    }

    func allergicTo(item: String) -> Bool {
        list().contains(item)
    }
    
    func list() -> [String] {
        var result = [String]()
        var points = allergiesPoints
        for (item, point) in itemsDict.sorted(by: { $0.1 > $1.1 }) {
            guard point == points else {
                result.insert(item, at: 0)
                break
            }
            guard point < points else { continue }
            points -= point
            result.insert(item, at: 0)
        }
        return result
    }
}


