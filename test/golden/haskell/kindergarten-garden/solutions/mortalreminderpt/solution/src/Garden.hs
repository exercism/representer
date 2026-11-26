module Garden
    ( Plant (..)
    , garden
    , lookupPlants
    ) where

data Plant = Clover
           | Grass
           | Radishes
           | Violets
           deriving (Eq, Show)

data Garden = Garden { students :: [String], plants :: [Plant]}

garden :: [String] -> String -> Garden
garden students plants = Garden {students = students, plants = plantsList}
  where plantsList = [matchPlant p|p<-plants, p `elem` ['G','C','R','V']]
    
matchPlant x
  | x == 'G' = Grass
  | x == 'C' = Clover
  | x == 'R' = Radishes
  | x == 'V' = Violets

lookupPlants :: String -> Garden -> [Plant]
lookupPlants student garden = result
  where
    Garden {students = sds, plants = pls } = garden
    studentId = [idx|idx<-[0..length sds - 1], (sds!!idx) == student]!!0
    nextLineId = (length pls) `div` 2
    result = [pls!!(2*studentId),pls!!(2*studentId+1),pls!!(2*studentId+nextLineId),pls!!(2*studentId+nextLineId+1)]