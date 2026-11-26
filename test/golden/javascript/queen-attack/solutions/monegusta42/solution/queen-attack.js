//
// This is only a SKELETON file for the 'Queen Attack' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class QueenAttack {
  constructor({
    black: [blackRow, blackColumn] = [0,3],
    white: [whiteRow, whiteColumn] = [7,3],
  } = {}) {
    if (whiteRow < 0 || whiteRow > 7 || blackRow < 0 || blackRow > 7 || whiteColumn < 0 || whiteColumn > 7 || blackColumn < 0 || blackColumn > 7) throw new Error("Queen must be placed on the board");
    if (whiteRow === blackRow && whiteColumn === blackColumn) throw new Error("Queens cannot share the same space");
    this.white = [whiteRow, whiteColumn];
    this.black = [blackRow, blackColumn];
  }

  toString() {
    let board = Array(8).fill("________").map(r => r.split(''));
    board[this.black[0]][this.black[1]] = 'B';
    board[this.white[0]][this.white[1]] = 'W';
    return board.map(r => r.join(' ')).join('\n');
  }

  get canAttack() {
    const dx = Math.abs(this.white[0] - this.black[0]);
    const dy = Math.abs(this.white[1] - this.black[1]);
    return !dx || !dy || dx === dy;
  }
}
