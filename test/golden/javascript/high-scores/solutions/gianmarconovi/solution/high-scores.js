//
// This is only a SKELETON file for the 'High Scores' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class HighScores {
    constructor(s) {
        this.s = s;
    }
    get scores() {
        return this.s;
    }
    get latest() {
        return this.s[this.s.length - 1];
    }
    get personalBest() {
        return Math.max(...this.s);
    }
    get personalTopThree() {
        return this.s.toSorted((a, b) => b - a).slice(0, 3);
    }
}
