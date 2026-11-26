using System;

public static class SimpleCalculator
{
    public static string Calculate(int operand1, int operand2, string operation)
    {
        switch(operation) {
            case "+": return display(operand1, operand2, operation, (operand1 + operand2));
            case "-": return display(operand1, operand2, operation, (operand1 - operand2));
            case "*": return display(operand1, operand2, operation, (operand1 * operand2));
            case "/": 
                if (operand2 == 0) {
                    return "Division by zero is not allowed."; 
                }
                return display(operand1, operand2, operation, (operand1 * operand2));
            default:
                if (operation == null) {
                    throw new ArgumentNullException();
                } else if (operation == "**") {
                    throw new ArgumentOutOfRangeException();
                } else {
                throw new ArgumentException();
                }
        }
    }
    private static string display(int operand1, int operand2, string operation, int result){
        return $"{operand1} {operation} {operand2} = {result}";
    }
}
