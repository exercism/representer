module AnnalynsInfiltration

let canFastAttack knightIsAwake = not knightIsAwake

let canSpy knightIsAwake archerIsAwake prisonerIsAwake =
  knightIsAwake || archerIsAwake || prisonerIsAwake

let canSignalPrisoner archerIsAwake prisonerIsAwake =
   prisonerIsAwake && not archerIsAwake

let canFreePrisoner knightIsAwake archerIsAwake prisonerIsAwake petDogIsPresent =
    if petDogIsPresent then not archerIsAwake
    else prisonerIsAwake && not archerIsAwake && not knightIsAwake
