module PhoneNumber
  ( phoneNumber
  ) where

import Control.Semigroupoid (compose)
import Data.Maybe (Maybe(..))
import Data.String.Regex (replace, test)
import Data.String.Regex.Flags (global, noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)

-- Function to clean the phone number
cleanNumber :: String -> String
cleanNumber number =
  let
    -- Regular expression to delete non-digits and trailing 1 from string
    cleaningRegex = unsafeRegex "(^[^0-9]*1|[^0-9])+" global
  in
    replace cleaningRegex "" number

-- Function to validate the phone number
validateNumber :: String -> Maybe String
validateNumber clean =
  let
    -- Regular expression to validate the phone number
    phoneNumberRegex = unsafeRegex "^[2-9]\\e{2}[2-9]\\d{6}$" noFlags
  in
    if test phoneNumberRegex clean then Just clean else Nothing

-- Main function to clean and validate the phone number
phoneNumber :: String -> Maybe String
phoneNumber = compose validateNumber cleanNumber
