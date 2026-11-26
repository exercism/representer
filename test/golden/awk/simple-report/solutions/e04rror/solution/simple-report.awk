BEGIN {
    FS=","
    # define the field separator
}

{
    first = $3 $4
    second = $5 $6
    average =  ( first + second ) / 2
    print "#"$1 ", " $2 " = " average
    # generate and print the output for each record
}
