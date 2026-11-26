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
             deriving (Eq, Show)

data Robot = Robot { bearing :: Bearing, coordinates :: (Integer, Integer) } deriving (Eq, Show)

advance :: Robot -> Robot
advance r = case bearing r of
    North -> r { coordinates = (x, y+1) }
    East  -> r { coordinates = (x+1, y) }
    South -> r { coordinates = (x, y-1) }
    West  -> r { coordinates = (x-1, y) } 
    where (x,y) = coordinates r

turnRight :: Robot -> Robot
turnRight r = case bearing r of
    North -> r { bearing = East }
    East  -> r { bearing = South }
    South -> r { bearing = West }
    West  -> r { bearing = North }

turnLeft :: Robot -> Robot
turnLeft r = case bearing r of
    North -> r { bearing = West }
    East  -> r { bearing = North }
    South -> r { bearing = East }
    West  -> r { bearing = South }

action :: Char -> Robot -> Robot
action 'A' = advance
action 'L' = turnLeft
action 'R' = turnRight
action _   = error "Invalid action"

mkRobot :: Bearing -> (Integer, Integer) -> Robot
mkRobot direction coords = Robot { bearing = direction , coordinates = coords }

move :: Robot -> String -> Robot
move = foldl (flip action)

