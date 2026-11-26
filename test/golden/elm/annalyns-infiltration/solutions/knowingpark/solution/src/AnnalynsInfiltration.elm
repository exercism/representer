module AnnalynsInfiltration exposing (canFastAttack, canFreePrisoner, canSignalPrisoner, canSpy, stealthAttackDamage)


canFastAttack : Bool -> Bool
canFastAttack knightIsAwake =
--    Debug.todo "Please implement this function"
    not knightIsAwake

canSpy : Bool -> Bool -> Bool -> Bool
canSpy knightIsAwake archerIsAwake prisonerIsAwake =
--    Debug.todo "Please implement this function"
    knightIsAwake || archerIsAwake || prisonerIsAwake

canSignalPrisoner : Bool -> Bool -> Bool
canSignalPrisoner archerIsAwake prisonerIsAwake =
--    Debug.todo "Please implement this function"
    (not archerIsAwake) && prisonerIsAwake


canFreePrisoner : Bool -> Bool -> Bool -> Bool -> Bool
canFreePrisoner knightIsAwake archerIsAwake prisonerIsAwake petDogIsPresent =
--    Debug.todo "Please implement this function"
    if petDogIsPresent then not archerIsAwake
    else (not knightIsAwake) && (not archerIsAwake) && prisonerIsAwake
        

stealthAttackDamage : Bool -> Int
stealthAttackDamage annalynIsDetected =
--    Debug.todo "Please implement this function"
    if annalynIsDetected then 7
    else 12