using System;
using System.Linq;

public static class Triangle
{
    public static bool IsScalene(double side1, double side2, double side3)
    {
        if (HowManyEqualSides(side1, side2, side3) == "Scalene")
        return true;
        else
        return false;
    }

    public static bool IsIsosceles(double side1, double side2, double side3) 
    {
        if (HowManyEqualSides(side1, side2, side3) == "Isosceles" || HowManyEqualSides(side1, side2, side3) == "Equilateral")
        return true;
        return false;
    }

    public static bool IsEquilateral(double side1, double side2, double side3) 
    {
        if (HowManyEqualSides(side1, side2, side3) == "Equilateral")
        return true;
        else
        return false;
    }

    public static string HowManyEqualSides(double side1, double side2, double side3) 
    {
        double[] sidesArray = [side1, side2, side3];
        int equalSideCounter = 0;

        if (IsTriangle(side1, side2, side3) == false)
        {
            return "false";
        }

        foreach (double side in sidesArray)
        {
            if (sidesArray.Count(count => count == side) == 3)
            {
                return "Equilateral";
            }
            else if (sidesArray.Count(count => count == side) == 2)
            {
                return "Isosceles";
            }
            else if (sidesArray.Count(count => count == side) == 1)
            continue;   

        } return "Scalene";
    } 

    public static bool IsTriangle(double side1, double side2, double side3)
    {
        if (side1 <= 0 || side2 <= 0 || side3 <= 0)
        return false;
        else if (side1 + side2 >= side3 && side2 + side3 >= side1 && side1 + side3 >= side2)
        return true;
        else
        return false;
    } 
}