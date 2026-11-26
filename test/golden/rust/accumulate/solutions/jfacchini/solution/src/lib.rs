/// What should the type of _function be?
pub fn map<T, U, R>(input: Vec<U>, mut function: T) -> Vec<R>
where
    T: FnMut(U) -> R
{
    let mut result = Vec::with_capacity(input.len());
    for elt in input {
        result.push(function(elt));
    }
    result
}
