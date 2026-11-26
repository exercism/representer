using System;
using System.Numerics;

public static class DiffieHellman
{
    public static BigInteger PrivateKey(BigInteger primeP) 
    {
        Random rand = new Random();        
        byte[] randomNumberBytes = new byte[primeP.ToByteArray().Length];
        rand.NextBytes(randomNumberBytes);
        return new BigInteger(randomNumberBytes,isUnsigned: true) % primeP + 1;
    }

    public static BigInteger PublicKey(BigInteger primeP, BigInteger primeG, BigInteger privateKey)=> BigInteger.ModPow(primeG,privateKey,primeP);
    

    public static BigInteger Secret(BigInteger primeP, BigInteger publicKey, BigInteger privateKey) => BigInteger.ModPow(publicKey,privateKey,primeP);
    
}