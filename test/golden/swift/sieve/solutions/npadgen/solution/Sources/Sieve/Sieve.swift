func sieve(limit: Int) -> [Int] {
    
    guard limit >= 2 else { return [] };
    
    var candidates = [Int](2...limit);
    var primes: [Int] = [];
    
    while candidates.count > 0 {
        let prime = candidates.removeFirst();
        primes.append(prime);
        candidates.removeAll(where: { $0.isMultiple(of: prime) })
    }
    return primes;
    
}
