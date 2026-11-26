//Solution goes in Sources
import Foundation

struct ComplexNumber {
    
    let realComponent: Double
    let imaginaryComponent: Double
    
    func absolute () -> Double {
        let x = self.realComponent
        let y = self.imaginaryComponent
       
        return (x*x + y*y).squareRoot()
    }
    
    func conjugate() -> ComplexNumber {
        return ComplexNumber(realComponent: self.realComponent, imaginaryComponent: -self.imaginaryComponent)
    }
    
    func exponent() -> ComplexNumber {
       
        
        return ComplexNumber(realComponent: exp(self.realComponent) * cos(self.imaginaryComponent), imaginaryComponent: exp(self.realComponent) * sin(self.imaginaryComponent))
    }
    
    func getRealComponent() -> Double {
        return realComponent
    }
    
    func getImaginaryComponent() -> Double {
        return imaginaryComponent
    }
    
    func multiply(complexNumber: ComplexNumber) -> ComplexNumber {
        let a = self.realComponent
        let b = self.imaginaryComponent
        let c = complexNumber.realComponent
        let d = complexNumber.imaginaryComponent
        
        return ComplexNumber(realComponent: (a*c-b*d), imaginaryComponent: (b*c+a*d))
    }
    
    func divide(complexNumber: ComplexNumber) -> ComplexNumber {
        let a = self.realComponent
        let b = self.imaginaryComponent
        let c = complexNumber.realComponent
        let d = complexNumber.imaginaryComponent
        
        return ComplexNumber(realComponent: (a * c + b * d)/(pow(c,2) + pow(d,2)) , imaginaryComponent: (b * c - a * d)/(pow(c,2) + pow(d,2)))
    }
    
    func add(complexNumber: ComplexNumber) -> ComplexNumber {
        let a = self.realComponent
        let b = self.imaginaryComponent
        let c = complexNumber.realComponent
        let d = complexNumber.imaginaryComponent
        
        return ComplexNumber(realComponent: a+c, imaginaryComponent: b+d)
    }
    
    func subtract(complexNumber: ComplexNumber) -> ComplexNumber {
        let a = self.realComponent
        let b = self.imaginaryComponent
        let c = complexNumber.realComponent
        let d = complexNumber.imaginaryComponent
        
        return ComplexNumber(realComponent: a-c, imaginaryComponent: b-d)
    }
    
}