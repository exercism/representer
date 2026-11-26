import java.util.ArrayList;
import java.util.List;

class DnDCharacter {

    private static final int INITIAL_HITPOINTS = 10;

    private int strenght;
    private int dexterity;
    private int constitution;
    private int intelligence;
    private int wisdom ;
    private int charisma;
 
    public DnDCharacter() {
        this.strenght = ability(rollDice());
        this.dexterity = ability(rollDice());
        this.constitution = ability(rollDice());
        this.intelligence = ability(rollDice());
        this.wisdom = ability(rollDice());
        this.charisma = ability(rollDice());
    }

    int ability(List<Integer> scores) {
        return scores.stream()
            .sorted()
            .skip(1)
            .mapToInt(Integer::valueOf).sum();
    }

    List<Integer> rollDice() {
        List<Integer> diceResults = new ArrayList<Integer>();
        for (int i = 0; i < 4; i++) {
            diceResults.add((int)(Math.random()*6) + 1);
        }
        return diceResults;
    }

    int modifier(int input) {
        return (int) Math.floor((input-10) / 2.0);
    }

    int getStrength() {
        return strenght;
    }

    int getDexterity() {
        return dexterity;
    }

    int getConstitution() {
        return constitution;
    }

    int getIntelligence() {
        return intelligence;
    }

    int getWisdom() {
        return wisdom;
    }

    int getCharisma() {
        return charisma;
    }

    int getHitpoints() {
        return INITIAL_HITPOINTS + modifier(getConstitution());
    }
}
