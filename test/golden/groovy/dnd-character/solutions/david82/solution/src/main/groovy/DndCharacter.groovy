import groovy.transform.ToString

import java.util.Random

@ToString
class DndCharacter {
    int strength
    int dexterity
    int constitution
    int intelligence
    int wisdom
    int charisma
    int hitpoints

    Random random = new Random()

    DndCharacter() {
        strength = ability()
        dexterity = ability()
        constitution = ability()
        intelligence = ability()
        wisdom = ability()
        charisma = ability()
        hitpoints = 10 + modifier(constitution)
    }

    int ability() {
        def rolls = (1..4).collect { rollDie() }.sort().drop(1)
        return rolls.sum()
    }

    int rollDie() {
        return random.nextInt(6) + 1
    }

    int modifier(int score) {
        return Math.floor((score - 10) / 2).toInteger()
    }
}
