export class DiffieHellman {
  p:number
  g:number
  
  constructor(p: number, g: number) {
    function isPrime(n:number):boolean {
      for (let i = 2; i < n; i++) {
        if (n%i==0){ return false}
      }
      return true
    }
    if(isPrime(p)&&isPrime(g)){this.p = p; this.g = g}else{
    throw new Error('Not Primes')}
  }

  public getPublicKey(privateKey: number): number {
    if (privateKey>=this.p||privateKey<=1){
      throw new Error ("Private Key must be between 1 and p.")
    }else{
      return (this.g**privateKey)%this.p
    }
  }

  public getSecret(theirPublicKey: number, myPrivateKey: number): number {
    return (theirPublicKey**myPrivateKey)%this.p
  }
}
