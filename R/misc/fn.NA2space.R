debug_message_l2("[misc] adding NA2space()")
NA2space <- function(df) 
  {
  
  # df %>% mutate_all(
  #   function(x)
  #      x = ifelse(is.na(x), "", x)
  #  )
  
  res <- df
  res[is.na(res)] <- ""
  res
}
