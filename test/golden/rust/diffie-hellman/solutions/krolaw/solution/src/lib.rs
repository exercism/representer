pub fn private_key(p: u64) -> u64 {
    p - 1 // Not very random
}

pub fn public_key(p: u64, g: u64, a: u64) -> u64 {
    // A = g**a mod p
    // g.pow(a as u32) % p
    modular_pow(g, a, p)
}

pub fn secret(p: u64, b_pub: u64, a: u64) -> u64 {
    // s = B**a mod p
    // b_pub.p(a as u32) % p
    modular_pow(b_pub, a, p)
}

pub fn modular_pow(base: u64, exponent: u64, modulus: u64) -> u64 {
    if modulus == 1 {
        return 0;
    }
    let mut result = 1;
    let mut base = base % modulus;
    let mut exponent = exponent;
    while exponent > 0 {
        if exponent % 2 == 1 {
            result = (result * base) % modulus;
        }
        exponent >>= 1;
        base = (base * base) % modulus;
    }
    result
}