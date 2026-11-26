module MonsterAttack exposing (..)


type alias MonsterDamage =
    String


attackWithSword1 : MonsterDamage -> Int -> MonsterDamage
attackWithSword1 monsterDamage strength =
    monsterDamage ++ "Attacked with sword of strength " ++ String.fromInt strength ++ "."
    -- Debug.todo "Implement attackWithSword1 function"


attackWithClaw1 : MonsterDamage -> Int -> MonsterDamage
attackWithClaw1 monsterDamage strength =
    monsterDamage ++ "Attacked with claw of strength " ++ String.fromInt strength ++ "."

    -- Debug.todo "Implement attackWithClaw1 function"


attack1 : MonsterDamage -> MonsterDamage
attack1 monsterDamage =
    let
        an = attackWithSword1 monsterDamage 5
        ka = attackWithClaw1 an 1
        ka2 = attackWithClaw1 ka 1
        an2 = attackWithSword1 ka2 5
    in
    an2
    -- Debug.todo "Implement attack1 function"


attackWithSword2 : Int -> MonsterDamage -> MonsterDamage
attackWithSword2 strength monsterDamage =
    monsterDamage ++ "Attacked with sword of strength " ++ String.fromInt strength ++ "."

    -- Debug.todo "Implement attackWithSword2 function"


attackWithClaw2 : Int -> MonsterDamage -> MonsterDamage
attackWithClaw2 strength monsterDamage =
    monsterDamage ++ "Attacked with claw of strength " ++ String.fromInt strength ++ "."

    -- Debug.todo "Implement attackWithClaw2 function"


attack2 : MonsterDamage -> MonsterDamage
attack2 monsterDamage =
    monsterDamage
        |> attackWithSword2 5
        |> attackWithClaw2 1
        |> attackWithClaw2 1
        |> attackWithSword2 5

    -- Debug.todo "Implement attack2 function"


attack3 : MonsterDamage -> MonsterDamage
attack3 =
    attackWithSword2 5 >> attackWithClaw2 1 >> attackWithClaw2 1 >> attackWithSword2 5

    -- Debug.todo "Implement attack3 function"
