struct PrimeFactorIterator {
    lower_bound: u64,
    upper_bound: u64,
}

impl PrimeFactorIterator {
    fn new(upper_bound: u64) -> PrimeFactorIterator {
        PrimeFactorIterator {
            lower_bound: 2,
            upper_bound,
        }
    }

    fn is_factor(&self) -> bool {
        self.upper_bound % self.lower_bound == 0
    }
}

impl Iterator for PrimeFactorIterator {
    type Item = u64;

    fn next(&mut self) -> Option<Self::Item> {
        while self.lower_bound <= self.upper_bound && !self.is_factor() {
            self.lower_bound += 1;
        }

        if self.lower_bound < self.upper_bound {
            self.upper_bound /= self.lower_bound;
            Some(self.lower_bound)
        } else {
            None
        }
    }
}

pub fn factors(n: u64) -> Vec<u64> {
    PrimeFactorIterator::new(n).collect()
}
