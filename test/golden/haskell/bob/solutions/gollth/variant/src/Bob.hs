module Bob (responseFor) where

import qualified Data.Text as T
import           Data.Text (Text)
import           Data.Char
import           Control.Applicative


andF :: Applicative f => f Bool -> f Bool -> f Bool
andF = liftA2 (&&)

isQuestion :: Text -> Bool
isQuestion = T.isSuffixOf "?"

isShout :: Text -> Bool
isShout xs | T.length letters /= 0 = False
           | otherwise             = T.all isUpper letters
  where letters = T.filter isAlpha xs

isShoutedQuestion :: Text -> Bool
isShoutedQuestion = isQuestion `andF` isShout

addressesHim :: Text -> Bool
addressesHim xs | T.length letters == 0 = True
                | otherwise             = "Bob" `T.isPrefixOf` xs
  where letters = T.filter isAlphaNum xs

responseFor :: Text -> Text
responseFor xs | isShoutedQuestion t = "Calm down, I know what I'm doing!"
               | isQuestion t        = "Sure."
               | isShout t           = "Whoa, chill out!"
               | addressesHim t      = "Fine. Be that way!"
               | otherwise           = "Whatever."
  where t = T.strip xs
