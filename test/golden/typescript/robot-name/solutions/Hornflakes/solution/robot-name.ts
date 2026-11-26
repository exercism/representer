export class Robot {
  private _name: string = '';
  private static usedNames: Set<string> = new Set();
  
  constructor() {
    this.resetName()
  }
  
  public get name(): string {
    return this._name;
  }

  public resetName(): void {
    const uppercases = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          numbers = '0123456789';
    
    do {
      this._name = this.randomLetter(uppercases) + this.randomLetter(uppercases)
        + this.randomLetter(numbers) + this.randomLetter(numbers) + this.randomLetter(numbers);
    } while(Robot.usedNames.has(this._name));
    Robot.usedNames.add(this._name);
  }

  public static releaseNames(): void {
    this.usedNames.clear();
  }

  private randomLetter(str: string) {
    return str.charAt(Math.floor(Math.random() * str.length ));
  }
}
