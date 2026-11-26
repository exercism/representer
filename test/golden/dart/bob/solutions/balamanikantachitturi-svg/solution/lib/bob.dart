class Bob {
  String response(String input) {
    final text = input.trim();

    // Silence
    if (text.isEmpty) {
      return 'Fine. Be that way!';
    }

    final hasLetters = RegExp(r'[A-Za-z]').hasMatch(text);
    final isShouting =
        hasLetters && text == text.toUpperCase();
    final isQuestion = text.endsWith('?');

    // Shouted question
    if (isShouting && isQuestion) {
      return "Calm down, I know what I'm doing!";
    }

    // Shouting
    if (isShouting) {
      return 'Whoa, chill out!';
    }

    // Question
    if (isQuestion) {
      return 'Sure.';
    }

    // Everything else
    return 'Whatever.';
  }
}