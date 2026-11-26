import re, strutils, tables

proc countWords*(s: string): CountTable[string] =
    s.toLowerAscii.findAll(rf"\w+('\w+)*").toCountTable
