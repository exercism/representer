module Matrix (saddlePoints) where

import Data.Array (Array)
import qualified Data.Array as A
import qualified Data.Ix as I

type Point = (Int, Int)

saddlePoints :: (Ord e) => Array Point e  -> [Point]
saddlePoints matrix = filter isSaddlePoint (A.indices matrix)
    where 
        isSaddlePoint i@(l,u) = all (element >=) row && all (element <=) column
            where 
                element = matrix A.! i
                associations = A.assocs matrix 
                row = [e | ((l1, _), e)<-associations, l1==l]
                column = [e | ((_, u1), e)<-associations, u1==u]