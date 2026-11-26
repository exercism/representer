#[derive(Debug)]
pub enum CalculatorInput {
    Add,
    Subtract,
    Multiply,
    Divide,
    Value(i32),
}

pub fn evaluate(inputs: &[CalculatorInput]) -> Option<i32> {
        let mut stack = Vec::new();
        for element in inputs {
            match element {
                CalculatorInput::Value(value) => stack.push(*value),
                _ => {
                    if stack.len() < 2 { return Option::None ;}
                    let arg2 = stack.pop().unwrap();
                    let arg1 = stack.pop().unwrap();
                    match element {
                        CalculatorInput::Add => stack.push(arg1+arg2),
                        CalculatorInput::Subtract => stack.push(arg1-arg2),
                        CalculatorInput::Divide => stack.push(arg1/arg2),
                        CalculatorInput::Multiply => stack.push(arg1*arg2),
                        _ => continue,
                    }

                }
            }
        }

        if stack.len() == 1 { return stack.pop();}
        return  Option::None;
    }
