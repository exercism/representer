#include "dnd_character.h"

int ability(void) {

  int min = INT_MAX;
  int sum = 0;
  
  srand(time(0));
  
  for ( int i = 0; i < 4; i++ ) {

    int num = rand() % 6 + 1;

    if ( num < min ) {
      min = num;
    }

    sum += num;
  }

  sum -= min;

  return sum;  
}

int modifier(int score) {

  int retval = 0;

  if ( score < 10 && score % 2 == 0 ) {
    retval = (score - 10) / 2 - 1;
  }
  else {
    retval = (score - 10) / 2;
  }

  return retval;
}

dnd_character_t make_dnd_character(void) {

  dnd_character_t retval;

  retval.strength = ability();
  retval.dexterity = ability();
  retval.constitution = ability();
  retval.intelligence = ability();
  retval.wisdom = ability();
  retval.charisma = ability();
  retval.hitpoints = 10 + modifier(retval.constitution);

  return retval;
}
