using System;

public static class Raindrops
{
	//
	// Given a number, outputs the appropriate text depending on whether number is divisible by 3, 5, or 7
	// 
	public static string Convert(int number)
	{
		string returnString = "";

		// If has 3 as a factor, output 'Pling'
		if (number % 3 == 0) returnString += "Pling";
		
		// If has 3 as a factor, output 'Pling'
		if (number % 5 == 0) returnString += "Plang";

		// If has 3 as a factor, output 'Pling'
		if (number % 7 == 0) returnString += "Plong";
		
		// If none of the above, return the input number
		if (returnString == "") returnString = number.ToString();

		return returnString;
	}
}