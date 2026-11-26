func totalBirdCount(_ birdsPerDay: [Int]) -> Int {
  var birdCount = 0
  for bird in birdsPerDay
  {
    birdCount+=bird
  }
  return birdCount
}

func birdsInWeek(_ birdsPerDay: [Int], weekNumber: Int) -> Int {
  let weekIndex = (weekNumber-1)*7
  var birdCount = 0
  for bird in weekIndex..<weekIndex-7
  {
    birdCount+=birdsPerDay[bird]
  }
  return birdCount
}

func fixBirdCountLog(_ birdsPerDay: [Int]) -> [Int] {
  var birds2 = Array(birdsPerDay)
  for i in stride(from:0, to:birdsPerDay.count, by:2)
  {
    birds2[i]+=1
  }
  return birds2
}
