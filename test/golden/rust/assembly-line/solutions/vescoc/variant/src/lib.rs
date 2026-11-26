// This stub file contains items which aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
//#![allow(unused)]

use std::{convert, ops};

const CARS_PER_HOUR: u8 = 221;

struct SuccessRate(f64);

impl convert::From<u8> for SuccessRate {
    fn from(value: u8) -> SuccessRate {
        match value {
            0..=4 => SuccessRate(1.0),
            5..=8 => SuccessRate(0.9),
            9..=10 => SuccessRate(0.77),
            _ => unreachable!(),
        }
    }
}

impl ops::Mul<f64> for SuccessRate {
    type Output = f64;

    fn mul(self, rhs: f64) -> Self::Output {
        let SuccessRate(lhs) = self;
        lhs * rhs
    }
}

pub fn production_rate_per_hour(speed: u8) -> f64 {
    SuccessRate::from(speed) * speed as f64 * CARS_PER_HOUR as f64
}

pub fn working_items_per_minute(speed: u8) -> u32 {
    (production_rate_per_hour(speed) * 60.0) as _
}
