module pangram;

import std.ascii; // For isAlpha, toLower

pure bool isPangram(immutable string str)
{
    // A boolean array to keep track of whether each letter from 'a' to 'z' has been seen.
    // The size 26 corresponds to the number of letters in the English alphabet.
    // All elements are initialized to false by default.
    bool[26] seenLetters;

    // Iterate through each character in the input string.
    foreach (char c; str)
    {
        // Convert the character to lowercase to ensure case-insensitivity.
        char lowerC = c.toLower;

        // Check if the character is an English alphabet letter.
        // Other characters (spaces, numbers, punctuation, etc.) are ignored.
        if (lowerC.isAlpha)
        {
            // Calculate the 0-indexed position of the letter (e.g., 'a' -> 0, 'b' -> 1).
            size_t index = lowerC - 'a';
            // Mark this letter as seen.
            seenLetters[index] = true;
        }
    }

    // After processing all characters, check if all 26 letters have been seen.
    // Iterate through the `seenLetters` array. If any letter has not been seen (is false),
    // then the string is not a pangram.
    foreach (bool seen; seenLetters)
    {
        if (!seen)
        {
            return false; // Found a missing letter, so it's not a pangram.
        }
    }

    // If the loop completes, it means all 26 letters were present.
    return true; // The string is a pangram.
}