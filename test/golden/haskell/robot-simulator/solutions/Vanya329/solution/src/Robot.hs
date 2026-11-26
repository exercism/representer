module Robot
    ( Bearing(East,North,South,West)
    , bearing
    , coordinates
    , mkRobot
    , move
    ) where
data Bearing = North
             | East
             | South
             | West
             deriving (Eq, Show, Enum)
data Robot = Robot {
               bearing :: Bearing,
               x :: Integer,
               y :: Integer
                   }
coordinates :: Robot -> (Integer, Integer)
coordinates robot = (x robot, y robot) 
mkRobot :: Bearing -> (Integer, Integer) -> Robot
mkRobot direction coords = Robot direction (fst coords) (snd coords)
move :: Robot -> String -> Robot
move robot [] = robot
move robot (z:zs) = move (doInstruction z) zs
  where doInstruction 'A' = advance robot
        doInstruction i = turn i robot
        advance (Robot North x' y') = mkRobot North (x', (y'+1)) 
        advance (Robot East x' y') = mkRobot East   ((x'+1), y')
        advance (Robot South x' y') = mkRobot South (x', (y'-1))
        advance (Robot West x' y') = mkRobot West   ((x'-1), y')
        turn 'R' (Robot direc x' y') = mkRobot (toEnum . (flip mod 4) $ fromEnum direc + 1) (x', y') 
        turn 'L' (Robot direc x' y') = mkRobot (toEnum . (flip mod 4) $ fromEnum direc - 1) (x', y') 
        turn _ _ = robot
 