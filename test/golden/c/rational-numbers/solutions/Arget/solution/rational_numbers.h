#ifndef RATIONAL_NUMBERS_H
#define RATIONAL_NUMBERS_H

typedef struct
{
    int numerator;
    int denominator;
}
rational_t;

int gcd(int a, int b);
float root(float r, int n);
rational_t reduce(rational_t r);
rational_t add(rational_t r1, rational_t r2);
rational_t subtract(rational_t r1, rational_t r2);
rational_t multiply(rational_t r1, rational_t r2);
rational_t divide(rational_t r1, rational_t r2);
rational_t absolute(rational_t r);
rational_t exp_rational(rational_t b, int e);
float exp_real(float b, rational_t e);

#endif
