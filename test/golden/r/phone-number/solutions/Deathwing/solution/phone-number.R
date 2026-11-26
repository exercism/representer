parse_phone_number <- function(number_string) {
    if(!number_string %>% stringr::str_extract("[:alpha:]") %>% is.na()) {return(NULL)}
    
    number <- number_string %>% 
        stringr::str_remove_all("^\\+?1 ?") %>% 
        stringr::str_remove_all("[:punct:]") %>%
        stringr::str_remove_all("[:blank:]") 
    if(nchar(number)!=10) {return(NULL)} 
    if(number %>% stringr::str_sub(1,1) %in% c(0,1)) {return(NULL)}
    if(number %>% stringr::str_sub(4,4) %in% c(0,1)) {return(NULL)}
    
    return(number)
}