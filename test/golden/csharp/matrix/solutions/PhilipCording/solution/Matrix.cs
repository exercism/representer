using System;
using System.Collections.Generic;
using System.Linq;

public class Matrix
{
    private readonly List<List<string>> _matrix = new();
    public Matrix(string input) => _matrix.AddRange(input.Split("\n").Select(row => row.Split(" ").ToList()));
    
    public int[] Row(int row) => _matrix[row - 1].Select(int.Parse).ToArray();
    
    public int[] Column(int col) => _matrix.Select(row => int.Parse(row[col - 1])).ToArray();
}