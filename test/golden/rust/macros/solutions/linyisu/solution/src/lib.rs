#[macro_export]
macro_rules! hashmap {
    (,) => {
        compile_error!("invalid syntax: lone comma");
    };
    ($($t1:expr => $t2:expr),*$(,)?) => {
        {
            let mut hm = ::std::collections::HashMap::new();
            $(
                hm.insert($t1, $t2);
            )*
            hm
        }
    };
}

/// This module contains doctests, which allows writing tests where a code
/// snippet is supposed to fail to compile. These tests also have "ignore"
/// attributes, makes sure to remove them when solving this exercise locally.
pub mod compile_fail_tests;
