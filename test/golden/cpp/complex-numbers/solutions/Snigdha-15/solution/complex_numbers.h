#if !defined(COMPLEX_NUMBERS_H)
#define COMPLEX_NUMBERS_H
#include <cmath>
namespace complex_numbers {
class Complex final {
private:
   const double a {}; // real part
   const double b {}; // imag part
public:
   explicit Complex(const double real_part,const double imag_part = 0)
   : a{real_part}, b{imag_part}{}
   double real() const noexcept {return a;}
   double imag() const noexcept {return b;}
   double abs() const noexcept {return std::sqrt(a*a + b*b);}
   Complex conj() const noexcept {return Complex{a,-b};}
   Complex exp() const noexcept {
       const double A = std::exp(a);
       return Complex{A*std::cos(b), A*std::sin(b)};
   }
};
Complex operator*(const Complex& c1, const Complex& c2);
Complex operator/(const Complex& c1, const Complex& c2);
Complex operator+(const Complex& c1, const Complex& c2);
Complex operator-(const Complex& c1, const Complex& c2);
Complex operator+(const double d, const Complex& c);
Complex operator+(const Complex& c, const double d);
Complex operator-(const double d, const Complex& c);
Complex operator-(const Complex& c, const double d);
Complex operator*(const double d, const Complex& c);
Complex operator*(const Complex& c, const double d);
Complex operator/(const double d, const Complex& c);
Complex operator/(const Complex& c, const double d);
}  // namespace complex_numbers
#endif  // COMPLEX_NUMBERS_H