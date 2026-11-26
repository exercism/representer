class Fighter {

    boolean isVulnerable() {
        return true;
    }

    int getDamagePoints(Fighter fighter) {
        return 1;
    }
}

class Warrior extends Fighter{
    public String toString(){
        return "Fighter is a Warrior";
    }

    boolean isVulnerable(){
        return false;
    }

    int getDamagePoints(Fighter fighter){
        return fighter.isVulnerable()?10:6;
    }
}

class Wizard extends Fighter {
    boolean spellPrepared = false;
    public String toString(){
        return "Fighter is a Wizard";
    }

    void prepareSpell(){
        spellPrepared = true;
    }

    boolean isVulnerable(){
        return !spellPrepared;
    }

    int getDamagePoints(Fighter fighter){
        return spellPrepared?12:3;
    }
    
}