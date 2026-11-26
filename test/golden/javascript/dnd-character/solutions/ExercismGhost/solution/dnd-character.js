const abilityModifier = (constitution) => {
  if (constitution < 3) throw new Error('Ability scores must be at least 3');
  if (constitution > 18) throw new Error('Ability scores can be at most 18')
  return Math.floor((constitution - 10) / 2);
};

const ABILITIES = [
  'strength', 'dexterity', 'constitution', 'intelligence' , 'wisdom', 'charisma',
];

class Character {
  constructor() {
    for (const ability of ABILITIES) {
      this[ability] = Character.rollAbility();
    }
    this.hitpoints = 10 + abilityModifier(this.constitution);
    //abilityModifier(this.constitution) ràng buộc các 3 <= Character.rollAbility(); <=18
  }

  static rollAbility() {
    const rolls = [0, 0, 0, 0]//gieo 4 lần
      .map(() => Math.floor(Math.random() * 6) + 1);//gtri moi lan từ 1 - 6
    return rolls
      .sort()//sắp xếp tăng dần
      .slice(1)//lần 3 lần cao nhít
      .reduce((accum, e) => accum + e, 0);//tính tổng 3 lần cao nhất
  }
}


export { Character, abilityModifier };