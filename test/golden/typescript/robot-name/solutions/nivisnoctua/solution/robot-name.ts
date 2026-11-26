export class Robot {
  _name = "";
  static _existingNames: string[] = [];
  constructor() {}

  public get name(): string {
    if(this._name === "") {
      this.resetName();
    }
    return this._name;
  }

  public resetName(): void {
    do {
      this._name = this.generateRandomName();
    }
    while(Robot._existingNames.includes(this._name));
    Robot._existingNames.push(this._name);
  }

  private generateRandomName(): string {
    return this.getRandomCharacters('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 2) + 
      this.getRandomCharacters('0123456789', 3);
  }

  private getRandomCharacters(chars:string, charCount: number) {
    let result = '';
    for(let i = 0; i < charCount; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }

  public static releaseNames(): void {
    Robot._existingNames = [];
  }
}
