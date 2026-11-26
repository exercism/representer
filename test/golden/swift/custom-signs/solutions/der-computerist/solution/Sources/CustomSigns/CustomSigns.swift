let birthday = "Birthday"
let valentine = "Valentine's Day"
let anniversary = "Anniversary"

let space: Character = " "
let exclamation: Character = "!"

func buildSign(for occasion: String, name: String) -> String {
    assert(
        [birthday, valentine, anniversary].contains(occasion),
        "`occasion` must be one of: Birthday, Valentine's Day, or Anniversary"
    )
    
    var happy = "Happy"
    happy.append(space)
    happy.append(occasion)
    happy.append(space)
    happy.append(name)
    happy.append(exclamation)
    return happy
}

func graduationFor(name: String, year: Int) -> String {
    "Congratulations \(name)!\nClass of \(year)"
}

func costOf(sign: String) -> Int {
    let basePrice = 20
    let characterCount = sign.count
    return basePrice + 2 * characterCount
}
