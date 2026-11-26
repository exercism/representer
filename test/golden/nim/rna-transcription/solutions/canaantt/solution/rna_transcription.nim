import strutils
import tables
import strformat

var refTable = {"C": "G", "G": "C", "T": "A", "A": "U"}.toTable

proc toRna*(str: string): string =
    var RNAString = ""
    if str == "":
        return RNAString
    for i in 0..<len(str):
        RNAString = RNAString & refTable[fmt"{str[i]}"]
    return RNAString