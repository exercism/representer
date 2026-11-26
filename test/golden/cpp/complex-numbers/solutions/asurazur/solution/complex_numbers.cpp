#include "complex_numbers.h"
namespace complex_numbers {
Complex operator*(const Complex& c1, const Complex& c2){
    return Complex{
        (c1.real() * c2.real() - c1.imag() * c2.imag()), 
        (c1.imag() * c2.real() + c1.real() * c2.imag())};
}
Complex operator/(const Complex& c1, const Complex& c2){
    const double d = c2.real()*c2.real() + c2.imag()*c2.imag();
    const auto A = Complex{1.0/d, 0.0};
    return A * (c1 * c2.conj());
}
Complex operator+(const Complex& c1, const Complex& c2){
    return Complex{(c1.real() + c2.real()), (c1.imag() + c2.imag())};
}
Complex operator-(const Complex& c1, const Complex& c2){
    return Complex{(c1.real() - c2.real()), (c1.imag() - c2.imag())};
}
Complex operator+(const double d, const Complex& c){
    return Complex{(d + c.real()), c.imag()};
}
Complex operator+(const Complex& c, const double d){
    return d + c;
}
Complex operator-(const double d, const Complex& c){
    return Complex{(d - c.real()), -c.imag()};
}
Complex operator-(const Complex& c, const double d){
    return (-d) + c;
}
Complex operator*(const double d, const Complex& c){
    return Complex{d * c.real(), d * c.imag()};
}
Complex operator*(const Complex& c, const double d){
    return d * c;
}
Complex operator/(const double d, const Complex& c){
    const double den = c.real()*c.real() + c.imag()*c.imag();
    const auto A = Complex{1.0/den, 0.0};
    return A * d * c.conj();
}
Complex operator/(const Complex& c, const double d){
    return (1.0/d) * c;
}
}  // namespace complex_numbers