module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let 
        cleanedString = (String.filter Char.isDigit phoneNumber)
        cleanedStringMinusStartingOne = 
            if String.startsWith "1" cleanedString  then
                (String.dropLeft 1 cleanedString)
            else 
                cleanedString
        cleanedToList = String.toList cleanedStringMinusStartingOne

        {- In JS it would be easy to transform a List of numbers as String to Int extract the first number from the list and check if it's smaller than 2 
        
        intList = case List.map String.toInt (List.map String.fromChar cleanedToList) of
                    Just list -> list
                    Nothing -> [0]
                
        (x :: xs) = intList 
        -}            
        checkValidN myString =
            (not (String.startsWith "0" myString)) && 
            (not (String.startsWith "1" myString))      
    in
           
    if (String.length cleanedStringMinusStartingOne) == 10 then
        if (checkValidN cleanedStringMinusStartingOne) && 
            (checkValidN (String.dropLeft 3 cleanedStringMinusStartingOne)) then
                Maybe.Just cleanedStringMinusStartingOne
        else
                Nothing
        
    else
        Nothing
    
        
        
    --Debug.todo "Please implement this function"
