package com.unitedhuskies.mandelbrot;

public class ComplexNumber
{
    double real;
    double coefficient;
    
    public ComplexNumber(final double real, final double coefficient) {
        this.real = real;
        this.coefficient = coefficient;
    }
    
    public ComplexNumber square() {
        final double real = Math.pow(this.real, 2.0) - Math.pow(this.coefficient, 2.0);
        final double complex = 2.0 * this.real * this.coefficient;
        return new ComplexNumber(real, complex);
    }
    
    public ComplexNumber plus(final ComplexNumber num) {
        this.real += num.real;
        this.coefficient += num.coefficient;
        return new ComplexNumber(this.real, this.coefficient);
    }
    
    public static ComplexNumber add(final ComplexNumber a, final ComplexNumber b) {
        final double real = a.real + b.real;
        final double coefficient = a.coefficient + b.coefficient;
        return new ComplexNumber(real, coefficient);
    }
    
    public static ComplexNumber multiply(final ComplexNumber a, final ComplexNumber b) {
        final double real = a.real * b.real - a.coefficient * b.coefficient;
        final double complex = a.real * b.coefficient + b.real * a.coefficient;
        return new ComplexNumber(real, complex);
    }
    
    @Override
    public String toString() {
        final StringBuilder x = new StringBuilder();
        if (this.real != 0.0) {
            x.append(Double.toString(this.real));
        }
        if (this.real != 0.0 && this.coefficient != 0.0) {
            x.append(" + ");
        }
        if (this.coefficient != 0.0) {
            x.append(String.valueOf(Double.toString(this.coefficient)) + "i");
        }
        return x.toString();
    }
    
    public double getCoefficient() {
        return this.coefficient;
    }
    
    public double getReal() {
        return this.real;
    }
    
    @Override
    public int hashCode() {
        return (int)Math.pow(Double.hashCode(this.real), Double.hashCode(this.coefficient));
    }
    
    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }
        final ComplexNumber cn = (ComplexNumber)obj;
        return cn.getCoefficient() == this.coefficient && cn.getReal() == this.real;
    }
}