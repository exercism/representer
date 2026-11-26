package diffiehellman

import (
	"crypto/rand"
	"math/big"
)

// PrivateKey generates a private key
// by randomly picking a number in range 2 to p
func PrivateKey(p *big.Int) *big.Int {
	var private = big.NewInt(1)
	var one = big.NewInt(1)

	for private.Cmp(one) <= 0 {
		private, _ = rand.Int(rand.Reader, p)
	}

	return private
}

// PublicKey generates a public key using the formula
// PublicKey = g**a mod p
func PublicKey(private, p *big.Int, g int64) *big.Int {
	public := big.NewInt(0).Exp(big.NewInt(g), private, p)
	return public
}

// NewPair generates a pair of private and public keys
func NewPair(p *big.Int, g int64) (private, public *big.Int) {
	private = PrivateKey(p)
	public = PublicKey(private, p, g)

	return
}

// SecretKey generates a public key using the formula
// SecretKey = PublicKey**PrivateKey mod p
func SecretKey(private1, public2, p *big.Int) *big.Int {
	secret := big.NewInt(0).Exp(public2, private1, p)
	return secret
}
