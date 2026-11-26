class CollatzConjecture {

    static int steps(int number) {
        def count = 0;

if(number <= 0)
throw new ArithmeticException("number not allowed")

while(number!=1)
{
if(number%2==0)
{
number = number/2;
count++
}
else{
number = (number*3)+1
count++
}
}
return count
    }
}