func sliceSize(diameter: Double?, slices: Int?) -> Double? {
  guard let diameter = diameter,
  let slices = slices,
  diameter > 0,
  slices > 0 else {
  return nil
    }
  let radius = diameter / 2
  let area = Double.pi * radius * radius
  return area / Double(slices)
}

func biggestSlice(
    diameterA: String, slicesA: String,
    diameterB: String, slicesB: String
) -> String {
    let sliceA = sliceSize(
        diameter: Double(diameterA),
        slices: Int(slicesA)
    )
    let sliceB = sliceSize(
        diameter: Double(diameterB),
        slices: Int(slicesB)
    )
    if (sliceA == nil && sliceB != nil) || diameterB == "0" {
        return "Slice B is bigger"
    } else if (sliceB == nil && sliceA != nil) || diameterA == "0" {
        return "Slice A is bigger"
    } else if let a = sliceA, let b = sliceB {
        if a > b {
            return "Slice A is bigger"
        } else if b > a {
            return "Slice B is bigger"
        }
    }
    return "Neither slice is bigger"
}