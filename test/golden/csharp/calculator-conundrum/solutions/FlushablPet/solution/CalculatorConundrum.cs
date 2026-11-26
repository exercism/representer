using System;

public static class SimpleCalculator
{
  static Func<int, int, int> Add = (int op1, int op2) => op1 + op2;
  static Func<int, int, int> Mult = (int op1, int op2) => op1 * op2;
  static Func<int, int, int> Div = (int op1, int op2) => op1 / op2;

  public static string Calculate(int operand1, int operand2, string operation)
  {
    if (operation == "/" && operand2 == 0) { return "Division by zero is not allowed."; }

    var op = operation switch
    {
      "/" => Div,
      "+" => Add,
      "*" => Mult,
      "" => throw new ArgumentException(),
      null => throw new ArgumentNullException(),
      _ => throw new ArgumentOutOfRangeException()
    };

    return $"{operand1} {operation} {operand2} = {op(operand1, operand2)}";
  }
}
