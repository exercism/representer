using System;


public class RailFenceCipher
{
    int rails;
    char filler = '#';
    char placeholder = '%';

    public RailFenceCipher(int numberRails)
    {
        rails = numberRails;
    }

    private char[,] PrepareFence(int x, int y)
    {
        char[,] fence = new char[x, y];
        bool _goUp = false;
        int _currentVertical = 0;

        for (int horizontal = 0; horizontal <= (y - 1); horizontal++)
        {

            //Set all characters in the row to something unique unless it should contain a letter, then put placeholder character
            for (int vertical = 0; vertical <= (x - 1); vertical++)
            {
                if (vertical == _currentVertical)
                    fence[vertical, horizontal] = placeholder;
                else
                    fence[vertical, horizontal] = filler;
                
            }

            if (_currentVertical == (x - 1))
                _goUp = true;
            if (_currentVertical == 0)
                _goUp = false;

            if (_goUp)
                _currentVertical--;
            else
                _currentVertical++;
        }
        return fence;
    }
   
    public void WriteFence(char[,] fence)
    {
        for (int i = 0; i < fence.GetLength(0); i++)
        {
            for (int j = 0; j < fence.GetLength(1); j++)
            {
                Console.Write(fence[i, j]);
            }
            Console.Write("\n");
        }
    }

    public string Encode(string input)
    {
        char[,] fence = PrepareFence(rails, input.Length);
        char[] inputCharArray = input.ToCharArray();

        //WriteFence(fence); //debugging
 
        
        //Fill the fence with the original message

        for (int i = 0; i < fence.GetLength(0); i++)
        {
            for (int j = 0; j < fence.GetLength(1); j++)
            {
                if (fence[i,j] == placeholder)
                {
                    fence[i, j] = inputCharArray[j];
                }
            }
        }

        //For debugging and making sure we're on the right track (pun intended)
        //Console.WriteLine("\n");
        //WriteFence(fence);

        //Extract the encoded message

        char[] encodedMessage = new char[input.Length];
        int characterInEncodedMessage = 0;

        for (int i = 0; i < fence.GetLength(0); i++)
        {
            for (int j = 0; j < fence.GetLength(1); j++)
            { 
                if (fence[i,j] != filler)
                    encodedMessage[characterInEncodedMessage++] = fence[i,j];
            }
        }

        string encodedMessageString = new string(encodedMessage);

        //Console.WriteLine(encodedMessageString); 
        
        return encodedMessageString;    
    }

        
    public string Decode(string input)
    {
        char[,] fence = PrepareFence(rails, input.Length);
        char[] inputCharArray = input.ToCharArray();
        char[] decodedMessage = new char[input.Length];

        //Fill the fence with the encoded message
        int characterNumber = 0;
        for (int i = 0; i < fence.GetLength(0); i++)
        {
            for (int j = 0; j < fence.GetLength(1); j++)
            {
                if (fence[i, j] == placeholder)
                {
                    fence[i, j] = inputCharArray[characterNumber++];
                }
            }
        }

        //Decode the fence
        for (int j = 0; j < fence.GetLength(1); j++)
        {
            for (int i = 0; i < fence.GetLength(0); i++)
            {
                if (fence[i, j] != filler)
                {
                    decodedMessage[j] = fence[i,j];
                }
            }
        }

        string decodedMessageString = new string(decodedMessage);

        //Debugging to make sure we're steaming in the right direction
        //WriteFence(fence);
        //Console.WriteLine(decodedMessageString);

        return decodedMessageString;

    }
}