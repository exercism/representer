module DND ( Character(..)
           , ability
           , modifier
           , character
           ) where

import Test.QuickCheck (Gen, choose)

data Character = Character
  { strength     :: Int
  , dexterity    :: Int
  , constitution :: Int
  , intelligence :: Int
  , wisdom       :: Int
  , charisma     :: Int
  , hitpoints    :: Int
  }
  deriving (Show, Eq)

-- Modifier function
modifier :: Int -> Int
modifier score = (score - 10) `div` 2

-- Roll 4 dice, drop lowest, sum rest
ability :: Gen Int
ability = do
  rolls <- sequence [choose (1,6), choose (1,6), choose (1,6), choose (1,6)]
  let total = sum rolls - minimum rolls
  return total

-- Generate full character
character :: Gen Character
character = do
  str <- ability
  dex <- ability
  con <- ability
  int <- ability
  wis <- ability
  cha <- ability
  let hp = 10 + modifier con
  return $ Character str dex con int wis cha hp
