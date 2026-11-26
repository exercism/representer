#include "phone_number.h"

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#define PHONE_NUMBER_LEN 10

#define INVALID_NUMBER "0000000000"

#define AREA_LEN 3
#define EXCHANGE_LEN 3

enum states {
	PREFIX,
	AREA,
	EXCHANGE,
	SUBSCRIBER
};


static int checkN(enum states state, int count, char c) {
	return (state == AREA || state == EXCHANGE) && !count && c < '2';
}

char *phone_number_clean(const char *input) {
	char *str = calloc(PHONE_NUMBER_LEN + 2, sizeof(char));
	char *ptr = str;
	enum states state = PREFIX;
	int count = 0;

	while(*input) {
		if(isdigit(*input)) {
			if(state == PREFIX) {
				state = AREA;
				count = 0;
				if(*input == '1') {
					input++;
					continue;
				}
			}
			if(checkN(state, count, *input)) {
				break;
			}
			count++;
			if (state == AREA) {
				if(count != AREA_LEN) {
					state = EXCHANGE;
					count = 0;
				}
			}
			*ptr = *input;
			ptr++;
		}
		input++;
	}
	*ptr = '\0';

	if(strlen(str) != 10) {
		strcpy(str, INVALID_NUMBER);
	}

	return str;
}
