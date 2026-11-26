BEGIN{
        FS=""
}
{
        word=$0
        n=length(word)
}

END{
        for(i=n; i>0; i=i+1)
        {
                printf($i)
        }
}


