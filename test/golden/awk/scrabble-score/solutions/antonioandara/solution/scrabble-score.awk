BEGIN {
    score["A"] = 1;
    score["L"] = 1;  
    score["E"] = 1;
    score["I"] = 1;
    score["N"] = 1;
    score["O"] = 1;
    score["R"] = 1;
    score["S"] = 1;
    score["T"] = 1;
    score["U"] = 1;
    score["D"] = 2;
    score["G"] = 2;
    score["M"] = 3;
    score["B"] = 3;
    score["C"] = 3;
    score["P"] = 3;
    score["F"] = 4;
    score["H"] = 4;
    score["V"] = 4;
    score["W"] = 4;
    score["Y"] = 4;
    score["K"] = 5;
    score["J"] = 8;
    score["X"] = 8;
    score["Q"] = 10;
    score["Z"] = 10;
}

{
  word = toupper($0)
  for (i = 1; i <= length(word); i++)
    {
     letter = substr(word, i, 1)
     points += score[letter]
    }
}

END{
    if (word=="")
        { print ",0" }
        else 
        { print word "," points }
}