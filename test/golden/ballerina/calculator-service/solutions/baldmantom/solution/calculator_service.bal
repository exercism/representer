import ballerina/http;

# Add the necessary attributes to this record to accept two operands and an operator.
#
# + operand1 - Is a float used as the first operand in an equation
# + operand2 - Is a float used as the second operand in an equation
# + operator - Is a string that represents the operator
public type Calculation record {|
    float operand1;
    float operand2;
    string operator;
|};

# Add the necessary attributes to this record to include the result value and the expression.
#
# + result - The result of the operation
# + expression - The evaluated expression that used to calculate the result
public type Response record {|
    float result;
    string expression;
|};

service / on new http:Listener(9090) {
    resource function post calc(Calculation calc) returns Response {
        match calc.operator {
            "+" => { return { result: calc.operand1 + calc.operand2, expression: getExpression(calc) }; }
            "-" => { return { result: calc.operand1 - calc.operand2, expression: getExpression(calc) }; }
            "x"|"*" => { return { result: calc.operand1 * calc.operand2, expression: getExpression(calc) }; }
            "/" => { return { result: calc.operand2 == 0.0 ? 0.0 : calc.operand1 / calc.operand2, expression: getExpression(calc) }; }
            _ => { return { result: 0.0, expression: getExpression(calc) }; }
        }
    }
}

function getExpression(Calculation calc) returns string {
    return calc.operand1.toString() + calc.operator + calc.operand2.toString();
}
