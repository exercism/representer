
# install.packages("stringr")
library(stringr)

# take two strings and calculate the hamming distance
hamming <- function(strand1, strand2) {
    len_a<-str_length(strand1)
    len_b<-str_length(strand2)
    if(len_a != len_b) error ("invalid")
    count<-0
    for(i in 1:len_a){
        a<-substring(strand1,i,i)
        b<-substring(strand2,i,i)
        if(a != b){
            count<-count+1
        }
    }
    count
}

# hamming("12345","12555")
