//
// This is only a SKELETON file for the 'D&D Character' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const abilityModifier = ability => {
  if (ability < 3) throw new Error('Ability scores must be at least 3');
  if (ability > 18) throw new Error('Ability scores can be at most 18');
  return Math.floor((ability - 10) / 2);
};

export class Character {

  constructor(){
    this.strength = Character.rollAbility();
    this.dexterity = Character.rollAbility();
    this.constitution = Character.rollAbility();
    this.intelligence = Character.rollAbility();
    this.wisdom = Character.rollAbility();
    this.charisma = Character.rollAbility();
    this.hitpoints = 10 + abilityModifier(this.constitution);
  }
  static rollAbility() {
    let dice = [];
  for (let index = 0; index < 4; index++) {
    dice.push( Math.floor(Math.random() * 6) + 1)
  }
  return dice.sort((a, b) => b - a).slice(0,3)
             .reduce((acc, cur) => acc += cur);
  }
}