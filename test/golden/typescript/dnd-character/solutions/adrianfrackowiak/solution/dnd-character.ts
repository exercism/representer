export class DnDCharacter {
 public static generateAbilityScore(): number {
    let arr: number[] = [Math.floor(Math.random() * 6) + 1, Math.floor(Math.random() * 6) + 1 , Math.floor(Math.random() * 6) + 1, Math.floor(Math.random() * 6) + 1 ]
    let discardLowest: number[] = arr.sort().filter((_,i) => i)
    let result: number = discardLowest.reduce((accumulator, value) => { return accumulator + value }, 0);
    return result
  }

  public static getModifierFor(abilityValue: number): number {
    return Math.floor((abilityValue - 10) / 2)
  }

  strength: number = DnDCharacter.generateAbilityScore()
  dexterity: number = DnDCharacter.generateAbilityScore()
  constitution: number = DnDCharacter.generateAbilityScore()
  intelligence: number = DnDCharacter.generateAbilityScore()
  wisdom: number = DnDCharacter.generateAbilityScore()
  charisma: number = DnDCharacter.generateAbilityScore()
  hitpoints: number = DnDCharacter.getModifierFor(this.constitution) + 10
}