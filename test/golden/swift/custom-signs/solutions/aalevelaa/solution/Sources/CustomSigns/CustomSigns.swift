let birthday = "Birthday"
let valentine = "Valentine's Day"
let anniversary = "Anniversary"

let space: Character = " "
let exclamation: Character = "!"


func buildSign(for occasion: String, name: String) -> String
{
    let spaceStr = String(space)
    let exclamationStr = String(exclamation)
    return "Happy" + spaceStr + occasion + spaceStr + name + exclamationStr
}

func graduationFor(name: String, year: Int) -> String
{
    return "Congratulations \(name)!\nClass of \(year)"
}

func costOf(sign: String) -> Int
{
    let baseCost = 20
    let charCost = 2
    
    return sign.count * charCost + baseCost
}

