export class Triangle {
  x: number;
  y: number;
  z: number;
  
  constructor(x: number, y: number, z: number) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  get isTriangle(): boolean {
    return (
      this.x > 0 && this.y > 0 && this.z > 0 && 
      (this.x + this.y >= this.z) && 
      (this.x + this.z >= this.y) && 
      (this.y + this.z >= this.x));
  }

  get isEquilateral(): boolean {
    return this.isTriangle && this.x === this.y && this.x === this.z && this.z === this.y;
  }

  get isIsosceles(): boolean {
    return this.isTriangle && (this.x == this.y || this.x == this.z || this.y == this.z);
  }

  get isScalene(): boolean {
    return this.isTriangle && this.x !== this.y && this.x !== this.z && this.z !== this.y;
  }
}