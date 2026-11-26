class Fighter {
    boolean isVulnerable() {
        return true;
    }

    public int getDamagePoints(Fighter enemy) {
        return 1;
    }

    @Override
    public String toString() {
        return "Fighter is a Fighter";
    }
}

class Warrior extends Fighter {
    private static final int WARRIOR_DAMAGE_ADVANTAGE = 10;
    private static final int WARRIOR_DAMAGE_DISADVANTAGE = 6;

    @Override
    boolean isVulnerable() {
        return false;
    }

    @Override
    public int getDamagePoints(Fighter enemy) {
        return enemy.isVulnerable()
            ? WARRIOR_DAMAGE_ADVANTAGE
            : WARRIOR_DAMAGE_DISADVANTAGE;
    }
    @Override
    public String toString() {
        return "Fighter is a Warrior";
    }
}

class Wizard extends Fighter {
    private boolean isPrepared = false;
    private static final int WIZARD_DAMAGE_ADVANTAGE = 12;
    private static final int WIZARD_DAMAGE_DISADVANTAGE = 4;

    @Override
    boolean isVulnerable() {
        return !isPrepared;
    }

    public void prepareSpell() {
        this.isPrepared = true;
    }

    @Override
    public int getDamagePoints(Fighter enemy) {
        return isPrepared
            ? WIZARD_DAMAGE_ADVANTAGE
            : WIZARD_DAMAGE_DISADVANTAGE;
    }

    @Override
    public String toString() {
        return "Fighter is a Wizard";
    }
}