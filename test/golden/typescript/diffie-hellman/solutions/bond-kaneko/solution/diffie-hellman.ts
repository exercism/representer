export class DiffieHellman {
  private p: number;
  private g: number;

  constructor(p: number, g: number) {
    if (p < 2 || g < 2) {
      throw new Error();
    }
    if (this.isNotPrimeNumber(p) || this.isNotPrimeNumber(g)) {
      throw new Error();
    }

    this.p = p;
    this.g = g;
  }

  public getPublicKey(privateKey: number): number {
    if (2 > privateKey) {
      throw new Error();
    }
    if (this.p <= privateKey) {
      throw new Error();
    }

    return this.g ** privateKey % this.p;
  }

  public getSecret(theirPublicKey: number, myPrivateKey: number): number {
    return theirPublicKey ** myPrivateKey % this.p;
  }

  private isNotPrimeNumber(n: number): boolean {
    for (let i = 2; i < n; i++) {
      if (n % i === 0) return true;
    }
    return false;
  }
}
