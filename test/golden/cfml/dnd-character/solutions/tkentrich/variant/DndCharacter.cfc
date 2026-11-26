/**
* Your implementation of the Dnd Character exercise
*/
component {
	// Implement strength, dexterity, constitution, wisdom, charisma, hitpoints

    this.strength = ability();
    this.dexterity = ability();
    this.constitution = ability();
    this.intelligence = ability();
    this.wisdom = ability();
    this.charisma = ability();
    this.hitpoints = 10 + abilityModifier(this.constitution);
    
	function abilityModifier( score ) {
		return int((score - 10) / 2);
	}
	
	function ability() {
        rolls = []
        for (i = 0; i <= 4; i++) {
            rolls.append(RandRange(1,6));
        }
		rolls.sort("numeric");
        rolls.deleteAt(1);
        return rolls.sum();
	}

}