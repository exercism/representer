#include "reverse_string.h"

char *reverse(const char *value)
{
	if (!value)
		return NULL;
	int len = strlen(value);
	char *rev = malloc((len + 1) * sizeof(char));
	if (!rev)
		return NULL;
	int i = 0;
	while (--len >= 0)
		rev[i++] = value[len];
	rev[i] = '\0';
	return rev;
}