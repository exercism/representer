//
// This is only a SKELETON file for the 'Crypto Square' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class Crypto {
  constructor(msg) {
    this.message = msg;
  }

  get ciphertext() {
    this.normalize();
    this.calcDimensions();
    this.breakIntoRecords();
    this.calcEncodedMessage();
    this.breakIntoChunks();

    return this.chunks.join(" ");
  }

  normalize() {
    this.normalMessage = this.message
                      .replace(/[^a-z0-9]/gi, "")
                      .toLowerCase();
  }

  calcDimensions() {
    let sqrt = Math.sqrt(this.normalMessage.length);

    this.cols = Math.ceil(sqrt);
    this.rows = Math.floor(sqrt);

    if(this.rows * this.cols < this.normalMessage.length) {
        this.rows++;
    }
  }

  breakIntoRecords() {
    this.paddedMessage = this.normalMessage.padEnd(this.rows * this.cols, " ");
    this.records = [];

    for(let i = 0; i < this.paddedMessage.length; i += this.cols) {
      this.records.push(this.paddedMessage.substr(i, this.cols));
    }
  }

  calcEncodedMessage() {
    let chars = [];

    for(let c = 0; c < this.cols; c++) {
      for(let r = 0; r < this.rows; r++) {
        let char = this.records[r].charAt(c);

        if(char != " ") {
          chars.push(char);
        }
      }
    }

    this.encodedMessage = chars.join("");
  }

  breakIntoChunks() {
    let n = this.rows * this.cols - this.encodedMessage.length;
    this.chunks = [];

    const chars = this.encodedMessage.split("");

    while(chars.length > 0) {
      if(n > 0) {
        chars.push(" ");
        n--;
      }

      const chunk = chars.splice(chars.length - this.rows, this.rows);
      this.chunks.unshift(chunk.join(""));
    }
  }

}
