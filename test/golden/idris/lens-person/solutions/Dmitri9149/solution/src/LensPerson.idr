module LensPerson

public export
record Lens s a b t where
    constructor MkLens
    view : s -> a  
    update : s -> b -> t
 
public export 
compose : Lens s a0 b0 t -> Lens a0 a1 b1 b0 -> Lens s a1 b1 t
compose (MkLens view0 update0) (MkLens view1 update1) = 
  MkLens (view1 . view0)    (\s,b1 => update0 s (update1 (view0 s) b1))

-------------------------------------------------------
public export 
record Address where
    constructor MkAddress
    street : String
    houseNumber : Int
    place : String
    country : String

public export
record Born where
    constructor MkBorn
    bornAt : Address
    bornOn : String

public export
record Person where
    constructor MkPerson
    name : String
    born : Born
    address : Address
--------------------------------------------

public export 
bornAtAddressLens : Lens Born Address Address Born 
bornAtAddressLens = MkLens bornAt (\s,b => ( { bornAt := b } s ) ) 

public export 
personBornLens : Lens Person Born Born Person 
personBornLens = MkLens born ((\s,b => { born := b } s )) 

public export 
personCurrentAddressLens : Lens Person Address Address Person 
personCurrentAddressLens = MkLens address (\s,b => ( { address := b } s) )

public export 
addressStreetLens : Lens Address String String Address 
addressStreetLens = MkLens street (\s,b => ( { street := b } s ) )

public export  
personStreetLens : Lens Person String String Person 
personStreetLens = personCurrentAddressLens `compose` addressStreetLens

export 
personBornStreetLens : Lens Person String String Person
personBornStreetLens = personBornLens `compose` (bornAtAddressLens `compose` addressStreetLens ) 

--------------------------------------------------------------

export
bornStreet : Born -> String
bornStreet = (bornAtAddressLens `compose` addressStreetLens).view 

export
setCurrentStreet : String -> Person -> Person
setCurrentStreet  = flip personStreetLens.update 

export
renameStreets : (String -> String) -> Person -> Person
renameStreets f person = 
  let updateCurrentStreet = personStreetLens.update person (f $  personStreetLens.view person)   
    in 
      let updateBornStreet = personBornStreetLens.update updateCurrentStreet (f $ personBornStreetLens.view updateCurrentStreet) 
        in updateBornStreet  