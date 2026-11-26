module crypto;

import std.stdio;

import std.uni, std.algorithm.iteration, std.conv, std.range;

class Cipher {
  string plain;
  bool normalized;
  this(in string s) {
    this(s, false);
  }

  private this(in string s, bool normalized) {
    this.plain = s;
    this.normalized = normalized;
  }

  pure string normalizePlainText() {
      return to!string(this.plain.filter!(c => isAlphaNum(c))).toLower;
  }

  pure ulong size() {
    ulong cols, rows;
    string s = this.normalizePlainText();
    
    while (cols*rows < s.length) {
      ++cols;
      if (cols*rows >= s.length)
	break;
      else
	++rows;
    }
    return cols;
  }

  string[] plainTextSegments() {
    return normalizePlainText()
      .chunks(size())
      .map!(chunk => chunk.to!string)
      .array;
  }

  string cipherText() {
    return this.plainTextSegments().transposed
      .join(normalized ? " " : "").to!string;
  }

  Cipher normalize() {
    return new Cipher(cipherText(), true);
  }
  
}

unittest
{
  immutable int allTestsEnabled = 1;

  // normalize_strange_characters
  {
    auto theCipher = new Cipher("s#$%^&plunk");
    assert("splunk" == theCipher.normalizePlainText());
  }

  // normalize_numbers
  {
    auto theCipher = new Cipher("1, 2, 3 GO!");
    assert("123go" == theCipher.normalizePlainText());
  }


  // size_of_small_square
  {
    auto theCipher = new Cipher("1234");
    assert(2U == theCipher.size());
  }


  // size_of_slightly_larger_square
  {
    auto theCipher = new Cipher("123456789");
    assert(3U == theCipher.size());
  }

  // size_of_non_perfect_square
  {
    auto theCipher = new Cipher("123456789abc");
    assert(4U == theCipher.size());
  }

  // size_of_non_perfect_square_less
  {
    auto theCipher = new Cipher("zomgzombies");
    assert(4U == theCipher.size());
  }


  // plain_text_segments_from_phrase
  {
    const string[] expected = [
			       "neverv", "exthin", "eheart", "withid", "lewoes"
			       ];
    auto theCipher = new Cipher("Never vex thine heart with idle woes");
    const auto actual = theCipher.plainTextSegments();

    assert(expected == actual);
  }

  // plain_text_segments_from_complex_phrase
  {
    const string[] expected = ["zomg", "zomb", "ies"];
    auto theCipher = new Cipher("ZOMG! ZOMBIES!!!");
    const auto actual = theCipher.plainTextSegments();

    assert(expected == actual);
  }

  {
    const string[] expected = ["ifmanwas", "meanttos", "tayonthe",
				"groundgo", "dwouldha", "vegivenu",
				"sroots"];
    auto theCipher = new Cipher("If man was meant to stay on the ground, god would have given us roots.");
    const auto actual = theCipher.plainTextSegments();

    assert(expected == actual);
  }

  {
    const string[] expected = ["timeis", "anillu", "sionlu", "nchtim",
			       "edoubl", "yso"];
    auto theCipher = new Cipher("Time is an illusion. Lunchtime doubly so.");

    const auto actual = theCipher.plainTextSegments();

    assert(expected == actual);

  }

          // Cipher_text_short_phrase
      {
	auto theCipher = new Cipher("Time is an illusion. Lunchtime doubly so.");
	assert("tasneyinicdsmiohooelntuillibsuuml" == theCipher.cipherText());


      }


            // Cipher_text_long_phrase
      {
	auto theCipher = new Cipher("We all know interspecies romance is weird.");
	assert("wneiaweoreneawssciliprerlneoidktcms" == theCipher.cipherText());
      }

            {
	auto theCipher = new Cipher("Madness, and then illumination.");
	assert("msemoaanindninndlaetltshui" == theCipher.cipherText());
      }




  static if (allTestsEnabled)
    {
   
   


    }

}
