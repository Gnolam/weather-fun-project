debug_message_l2("[misc] adding check_mem()")
check_mem <- function(){ #tolerance = 0){
  debug_message_l2("~> check_mem()")  
  
  # Get the parent env
  penv <- parent.frame() 
  
  for (itm in ls(envir = penv) ) {
    sz =  object_size(itm)
    #if(sz > tolerance){
        debug_message_l4(sz %>%  capture.output() , "\t",itm)
    #}
  }
#  debug_message_end("check_mem() <<")  
}


 # f1 <- function() {
 #   a = 2
 #   b = 3
 #   c= 4
 #   check_mem()
 #   print(ls())
 # }
 # f1()
