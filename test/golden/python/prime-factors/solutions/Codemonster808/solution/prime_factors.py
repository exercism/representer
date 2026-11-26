def factors(value):
    divisor = 2
    resultado = []
    while value > 1:
        if value % divisor != 0:
            divisor += 1
        else:
            resultado.append(divisor)
            value //= divisor 
    return resultado
             
