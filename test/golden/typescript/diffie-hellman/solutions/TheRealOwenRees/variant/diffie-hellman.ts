export class DiffieHellman {
  private readonly _p: number;
  private readonly _g: number;

  constructor(p: number, g: number) {
    if (p < 1 || g < 1) throw new Error('argument is out of range')
    if (!DiffieHellman.isPrime(p) || !DiffieHellman.isPrime(g)) throw new Error('arguments are not prime')
    this._p = p
    this._g = g
  }

  static isPrime(num: number): boolean {
    return (num > 1) && Array(Math.floor(Math.sqrt(num)) + 1).fill(0).map((_, i) => i + 2).every(i => num % i !== 0);
  }

  public getPublicKey(privateKey: number): number {
    if (privateKey < 2 || privateKey >= this._p) throw new Error('Private key out of range')
    return this._g ** privateKey % this._p
  }

  public getSecret(theirPublicKey: number, myPrivateKey: number): number {
    return theirPublicKey ** myPrivateKey % this._p
  }
}
