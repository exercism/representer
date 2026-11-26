import math
class ComplexNumber:
    def __init__(self, real, imaginary):
        self.real = real
        self.imaginary = imaginary

    def __eq__(self, other):
        return self.real == other.real and self.imaginary == other.imaginary

    def __add__(self, other):
        if isinstance(other, ComplexNumber):
            return ComplexNumber(self.real+other.real, self.imaginary+other.imaginary)
        return ComplexNumber(self.real+other, self.imaginary)

    def __radd__(self, other):
        return ComplexNumber(other+self.real, self.imaginary)

    def __mul__(self, other):
        if isinstance(other, ComplexNumber):
            a = self.real*other.real - (self.imaginary*other.imaginary)
            b = self.real*other.imaginary + self.imaginary*other.real
            return ComplexNumber(a, b)
        return ComplexNumber(self.real*other, self.imaginary*other)

    def __rmul__(self, other):
        return ComplexNumber(other*self.real, other*self.imaginary)
        
    def __sub__(self, other):
        if isinstance(other, ComplexNumber):
            return ComplexNumber(self.real-other.real, self.imaginary-other.imaginary)
        return ComplexNumber(self.real-other, self.imaginary)

    def __rsub__(self, other):
        return ComplexNumber(other-self.real, -self.imaginary)

    def __truediv__(self, other):
        if isinstance(other, ComplexNumber):
            if other.imaginary == 0:
                return ComplexNumber(self.real/other.real, self.imaginary/other.real)
            else:
                denom = other.real**2 + other.imaginary**2
                numer_real = (self.real*other.real) + (self.imaginary*other.imaginary)
                numer_imaginary = (self.imaginary*other.real) - (self.real*other.imaginary)
                return ComplexNumber(numer_real/denom, numer_imaginary/denom)
        return ComplexNumber(self.real/other,self.imaginary/other)

    def __rtruediv__(self, other):
        denom = self.real**2 + self.imaginary**2
        numer_real = other*self.real
        numer_imaginary = other*(-self.imaginary)
        return ComplexNumber(numer_real/denom, numer_imaginary/denom)
        
    def __abs__(self):
        return math.sqrt(self.real**2 + self.imaginary**2)

    def conjugate(self):
        return ComplexNumber(self.real, -self.imaginary)

    def exp(self):
        a = math.exp(self.real)*math.cos(self.imaginary)
        b = math.exp(self.real)*math.sin(self.imaginary)
        return ComplexNumber(a,b)
