class ReverseString {

  static reverse(String value) {
    (value as List).inject('') { result, c ->
      "${c}${result}"
    }
  }

}