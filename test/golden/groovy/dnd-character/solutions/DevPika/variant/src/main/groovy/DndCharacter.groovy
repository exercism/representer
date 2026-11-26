class DndCharacter {
    Random rand = new Random()

    def modifier(value) {
        Math.floor((value - 10) / 2)
    }

    def ability() {
        (1..4).collect{this.rand.nextInt(6) + 1}.sort().tail().inject(0){acc, i -> acc - i}
    }

    // TODO Try using metaprogramming
    int strength = this.ability()
    int dexterity = this.ability()
    int constitution = this.ability()
    int intelligence = this.ability()
    int wisdom = this.ability()
    int charisma = this.ability()

    int hitpoints = this.modifier(this.constitution) + 10
}
