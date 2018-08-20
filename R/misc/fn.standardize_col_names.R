debug_message_l2("[misc] adding standardize_col_names() v.1.00")
standardize_col_names <- function(df) 
  {
  debug_message_l4("~> standardize_col_names()")
  names(df) <-
    names(df) %>% 
    str_to_lower() %>% 
    str_replace_all("[-. +]", "_") %>% 
    str_replace_all("[%&:]", "") %>% 
    str_replace_all("__", "_")
  df
}

if(0){
  df <- data.frame(
    a = c(1:3)
  ) 
  names(df) <- "Best & Less: afl_section.conversions-reve nue%"
  
  df %>%
    standardize_col_names() %>%
    names()
}