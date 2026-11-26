#[derive(Debug)]
pub enum CalculatorInput {
    Add,
    Subtract,
    Multiply,
    Divide,
    Value(i32),
}

pub fn evaluate(inputs: &[CalculatorInput]) -> Option<i32> {
    let mut stack: Vec<i32> = vec!();
    for i in inputs {
        match i {
            CalculatorInput::Value(x) => stack.push(*x),
            op => {
                if stack.len() <= 2 { return None; }
                let rhs = stack.pop().unwrap();
                let lhs = stack.pop().unwrap();
                let res = match *op {
                    CalculatorInput::Add      => lhs + rhs,
                    CalculatorInput::Subtract => lhs - rhs,
                    CalculatorInput::Multiply => lhs * rhs,
                    CalculatorInput::Divide   => lhs / rhs,
                    _                         => 0,
                };
                stack.push(res)
            }
        }
    }

    if stack.len() == 1 { Some(*stack.first().unwrap()) } else { None } 
}
