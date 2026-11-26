// Put your code here
// Letter                           Value
// A, E, I, O, U, L, N, R, S, T       1
// D, G                               2
// B, C, M, P                         3
// F, H, V, W, Y                      4
// K                                  5
// J, X                               8
// Q, Z                               10

int score(String name){
  int res = 0;
  name.toUpperCase().split('').forEach((letter) {
    switch(letter){
      case 'A':
      case 'E':
      case 'I':
      case 'O':
      case 'U':
      case 'L':
      case 'N':
      case 'R':
      case 'S':
      case 'T': res += 1; break;
      case 'D':
      case 'G': res += 2; break;
      case 'B':
      case 'C':
      case 'M':
      case 'P': res += 3;break;
      case 'F':
      case 'H':
      case 'V':
      case 'W':
      case 'Y': res += 5;break;
      case 'K': res += 5;break;
      case 'J':
      case 'X': res += 8 ;break;
      case 'Q':
      case 'Z': res += 10 ;break;
    }
  });

  return res;
}
