# These variables are initialized on the command line (using '-v'):
# - num
BEGIN {x=num+0;if (x%3==0) D=D"Pling"; if (x%5==0) D=D"Plang"; if (x%7==0) D=D"Plong"; if (D!="") {print D} else {print x}}