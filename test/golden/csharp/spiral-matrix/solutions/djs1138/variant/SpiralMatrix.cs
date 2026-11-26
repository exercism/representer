using System;
using System.Collections.Generic;
using System.Linq;
public class SpiralMatrix
{
        enum Direction
        {
            Up,
            Down,
            Left,
            Right
        }
      
        public static int[,] GetMatrix(int size)
        {   
            int[,] matrix = new int[size,size];
            int M = 0;
            int N = 0;

            List<int> sides = new List<int>();
            for (int i = size; i >= 1; i--)
            {
                sides.Add(i);
                if (i != size) 
                    sides.Add(i);
            }
            
            int top_right = 1;
            int bottom_right = 2;
            int bottom_left = 3;
            int top_left = 4;

            Direction direction = Direction.Right;
            for (int i = 1; i < size * size; i++)
            {
                switch (direction)
                {
                    case Direction.Right:
                        if (i == sides.Take(top_right).Sum())
                        {
                            matrix[M++, N] = i;
                            top_right += 4;
                            direction = Direction.Down;
                        }
                        else
                            matrix[M, N++] = i;
                        break;

                    case Direction.Down:
                        if (i == sides.Take(bottom_right).Sum())
                        {
                            matrix[M, N--] = i;                            
                            bottom_right += 4;
                            direction = Direction.Left;
                        }
                        else
                            matrix[M++, N] = i;
                        break;

                    case Direction.Left:
                        if (i == sides.Take(bottom_left).Sum())
                        {
                            matrix[M--,N] = i;                            
                            bottom_left += 4;
                            direction = Direction.Up;
                        }
                        else
                            matrix[M, N--] = i; 
                        break;

                    case Direction.Up:
                        if (i == sides.Take(top_left).Sum())
                        {
                            matrix[M, N++] = i;
                            top_left += 4;
                            direction = Direction.Right;
                        }
                        else
                            matrix[M--, N] = i;
                        break;

                    default:
                        break;
                }
            }
            return matrix;
        }
}
