using System;
using System.Collections.Generic;

//based on chaley33's solution. I basically only commented their code and formatted it to my liking :)
public static class MatchingBrackets
{
    //Create a Dictionary to easily access the list of brackets to check
    private static readonly Dictionary<char, char> bracketDictionary = new Dictionary<char, char>()
    {
        {'{','}'}, 
        {'[',']'}, 
        {'(',')'},
    };

    public static bool IsPaired(string input)
    {
    //Create a stack that will be populated by any character in input that match one in the Dictionary
       var bracketStack = new Stack<char>();

        foreach (var character in input)
        {
            //populates the Stack with the first character that matches one of the elements in the Dictionary
            if(bracketDictionary.ContainsKey(character))
            {
                bracketStack.Push(bracketDictionary[character]);
            }
            //checks if the character is a value contained in the Dictionary and if it's the last one in the Stack. If it's not, or if the popped character wasn't the one being analyzed, it means it's not a closing bracket, and thus the brackets are not matched.
            else if(bracketDictionary.ContainsValue(character) && (!bracketStack.TryPop(out char popped) || popped != character))
            {
                return false;
            }
        }
        return bracketStack.Count == 0;
    }
}