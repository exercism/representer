import ballerina/http;

public type Calculation record {|
    float  operand1;
    float  operand2;
    string operator;
|};

public type Response record {|
    float  result;
    string expression;
|};

service / on new http:Listener(9090) {
    resource function post calc(@http:Payload Calculation input) returns Response {

        float  op1  = <float>input.operand1;
        float  op2  = <float>input.operand2;
        string x    = input.operand1.toString() + input.operator + input.operand2.toString();
        
        float r = 0.0;
        match input.operator {
            "+"     => { r = op1 + op2; }
            "-"     => { r = op1 - op2; }
            "x"|"*" => { r = op1 * op2; }
            "/"     => { r = op1 / op2; }
        }


        return { "result": r, "expression": x };
    }
}