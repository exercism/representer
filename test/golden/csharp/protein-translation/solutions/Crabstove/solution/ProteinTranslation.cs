using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;

public static class ProteinTranslation
{
    public static string[] Proteins(string strand)
    {
        Dictionary<string, string> codonsAminoAcids = new Dictionary<string, string>();
        codonsAminoAcids.Add("AUG", "Methionine");
        codonsAminoAcids.Add("UUU", "Phenylalanine");
        codonsAminoAcids.Add("UUC", "Phenylalanine");
        codonsAminoAcids.Add("UUA", "Leucine");
        codonsAminoAcids.Add("UUG", "Leucine");
        codonsAminoAcids.Add("UCU", "Serine");
        codonsAminoAcids.Add("UCC", "Serine");
        codonsAminoAcids.Add("UCA", "Serine");
        codonsAminoAcids.Add("UCG", "Serine");
        codonsAminoAcids.Add("UAU", "Tyrosine");
        codonsAminoAcids.Add("UAC", "Tyrosine");
        codonsAminoAcids.Add("UGU", "Cysteine");
        codonsAminoAcids.Add("UGC", "Cysteine");
        codonsAminoAcids.Add("UGG", "Tryptophan");
        codonsAminoAcids.Add("UAA", "STOP");
        codonsAminoAcids.Add("UAG", "STOP");
        codonsAminoAcids.Add("UGA", "STOP");
                
        List <string> result = new List<string>();
        List <string> codons = new List<string>();
        string pattern = "...";

        foreach(Match match in Regex.Matches(strand, pattern)){
            codons.Add(match.Value);
        }

        foreach(string codon in codons){
            string value = "";
            if(codonsAminoAcids.TryGetValue(codon, out value)){
                if(value == "STOP") break;
                result.Add(value);
            }
        }

        string[] resultArr = result.ToArray();
        return resultArr;
    }
}