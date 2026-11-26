#include "acronym.h"
namespace acronym {
std::string acronym(std::string cadena) {
  int contador_caracteres{0};
  while (cadena[contador_caracteres] != '\0') {
    ++contador_caracteres;
  }
  std::string acronimo{""};
  acronimo += cadena[0];
  for (int i{0}; i < contador_caracteres; ++i) {
    if (cadena[i] == ' ' || cadena[i] == '-' || cadena[i] == '_') {
      if (cadena [i + 1] <= 'z' && cadena[i + 1] >= 'a') {
        acronimo += (cadena[i + 1] - 32);
      }
      if (cadena [i + 1] <= 'Z' && cadena[i + 1] >= 'A') {
        acronimo += cadena[i + 1];   
      }
    }
  }
  return acronimo;
} 
} // namespace acronym
