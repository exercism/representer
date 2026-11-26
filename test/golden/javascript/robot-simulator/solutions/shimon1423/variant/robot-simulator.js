//
// This is only a SKELETON file for the 'Robot Simulator' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class InvalidInputError extends Error {
  constructor(message) {
    super();
    this.message = message || 'Invalid Input';
  }
}
export class Robot {

  constructor(){
    this.direction = 'north';
  }
  get bearing() {
    return this.direction;
  }

  get coordinates() {
    return [this.x, this.y];
  }  

  place(data) {
    if(['north','east','south','west'].indexOf(data.direction) < 0)
      throw new InvalidInputError();
    this.x = data.x;
    this.y = data.y;
    this.direction = data.direction;
  }

  getNewDirection(move) {
    switch(this.bearing){
      case 'north':
        return move == 'R' ? 'east' : 'west';
      case 'east':
        return move == 'R' ? 'south' : 'north';
      case 'south':
        return move != 'R' ? 'west' : 'east';
      case 'west':
        return move == 'R' ? 'north' : 'south';
    }
  }

  evaluate(instructions) {
    for (let i = 0; i < instructions.length; i++) {
      if(instructions[i] == 'A'){
        switch(this.bearing){
          case 'north':
            this.y++;
            break;
          case 'east':
            this.x++;
            break;
          case 'south':
            this.y--;
            break;
          case 'west':
            this.x--;
            break;
        }
      }
      else
          this.direction = this.getNewDirection(instructions[i]);
    }
  }
}
