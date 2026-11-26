BEGIN { FS = "" }

{
    for (i = NF; i > 0; i--)
        output_string = output_string $i
    print output_string
}