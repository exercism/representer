#pragma once
#include <cmath>

namespace complex_numbers {

    struct Complex{
        Complex(double real, double imag = 0) : real_part(real), imaginary_part(imag) {}
        double real() const {return real_part;}
        double imag() const {return imaginary_part;}
        double abs() const {return std::sqrt(real_part*real_part + imaginary_part*imaginary_part);}
        Complex conj() const {
            return Complex(real_part, -imaginary_part);
        }
        Complex exp() const {
            return std::exp(real_part) * Complex(std::cos(imaginary_part), std::sin(imaginary_part));
        }
        friend Complex operator+(const Complex c1, const Complex c2) {return Complex(c1.real()+c2.real(), c1.imag()+c2.imag());}
        friend Complex operator-(const Complex c1, const Complex c2) {return Complex(c1.real()-c2.real(), c1.imag()-c2.imag());}
        friend Complex operator*(const Complex c1, const Complex c2) {
            return Complex(c1.real()*c2.real() - c1.imag()*c2.imag(),c1.real()*c2.imag() + c1.imag()*c2.real());
        }
        friend Complex operator/(const Complex c1, const Complex c2) {
            return 1 / (c2.abs()*c2.abs()) * c1 * c2.conj();
        }    
        private:
        double real_part{0};
        double imaginary_part{0};
    };


}  // namespace complex_numbers
