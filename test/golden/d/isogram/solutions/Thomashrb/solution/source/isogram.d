module isogram;

import std.ascii : toLower, isAlpha;
import std.array : array;
import std.algorithm.sorting : sort;
import std.algorithm.iteration : filter, uniq, map;

bool isIsogram(string s)
{
  auto sChars = s
    .filter!(isAlpha)
    .map!(toLower)
    .array();

  auto sUniq = sChars
    .sort()
    .uniq()
    .array();

  return sChars == sUniq;
}

unittest
{
  immutable int allTestsEnabled = 1;

  // Empty string
  assert(isIsogram(""));

  static if (allTestsEnabled)
  {
    // Isogram with only lower case characters
    assert(isIsogram("isogram"));

    // Word with one duplicated character
    assert(!isIsogram("eleven"));

    // Word with one duplicated character from the end of the alphabet
    assert(!isIsogram("zzyzx"));

    // Longest reported english isogram
    assert(isIsogram("subdermatoglyphic"));

    // Word with duplicated character in mixed case
    assert(!isIsogram("Alphabet"));

    // Word with duplicated character in mixed case, lowercase first
    assert(!isIsogram("alphAbet"));

    // Hypothetical isogrammic word with hyphen
    assert(isIsogram("thumbscrew-japingly"));

    // Hypothetical word with duplicated character following hyphen
    assert(!isIsogram("thumbscrew-jappingly"));

    // Isogram with duplicated hyphen
    assert(isIsogram("six-year-old"));

    // Made-up name that is an isogram
    assert(isIsogram("Emily Jung Schwartzkopf"));

    // Duplicated character in the middle
    assert(!isIsogram("accentor"));

    // Same first and last characters
    assert(!isIsogram("angola"));
  }
}
