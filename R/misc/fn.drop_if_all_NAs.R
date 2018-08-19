debug_message_l2("[misc] drop_if_all_NAs() v1.2")
drop_if_all_NAs <- function(df){
  debug_message_l4(" ~> drop_if_all_NAs()")
  
  res <- df
  
  res <- Filter(function(x)!all(is.na(x)), res)
#  res <- Filter(function(x)!all(x==""), res)
  
  res
}


if(0){
  
  df<- report
  drop_if_all_NAs(report) %>% names()
}