BEGIN {
    score["A"] = 1;
    score["B"] = 3;
    score["C"] = 3;
    score["D"] = 2;
    score["E"] = 1;
    score["F"] = 4;
    score["G"] = 2;
    score["H"] = 4;
    score["I"] = 1;
    score["J"] = 8;
    score["K"] = 5;
    score["L"] = 1;
    score["M"] = 3;
    score["N"] = 1;
    score["O"] = 1;
    score["P"] = 3;
    score["Q"] = 10;
    score["R"] = 1;
    score["S"] = 1;
    score["T"] = 1;
    score["U"] = 1;
    score["V"] = 4;
    score["W"] = 4;
    score["X"] = 8;
    score["Y"] = 4;
    score["Z"] = 10;
    score[" "] = 0;
}
{
    word = toupper($0)
    split(word, arr, "");
    total = 0;
    for (i in arr)
        total += score[arr[i]];
    print word "," total;
}
