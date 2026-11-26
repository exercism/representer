# These variables are initialized on the command line (using '-v'):
# - num
 
BEGIN {
    resultado=""
    if(num%3==0){
        resultado= resultado "Pling"
    } if(num %5==0){
        resultado= resultado "Plang"
    }    
        if(num%7==0){
            resultado=resultado "Plong"
        }
if(num%3!=0 && num%5!=0 && num%7!=0){
    resultado=num
}
print resultado
 
}
