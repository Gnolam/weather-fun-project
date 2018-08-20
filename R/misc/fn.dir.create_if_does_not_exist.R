debug_message_l2("[misc] adding dir.create_if_does_not_exist() v1.06")
dir.create_if_does_not_exist <- function(init_path, clean_it = TRUE) {
  debug_message_l2("~> dir.create_if_does_not_exist('",init_path,"', clean_it = ",clean_it,")")
  
  
  path <- ifelse(
    tools::file_ext(init_path) == "",
    init_path,
    dirname(init_path)
  )

  if (!dir.exists(path))
  {
    # Debug only if we are going to do anything about it
    if(path != init_path)
      debug_message_l4(
        "Force reduce path to:\n\t",
        init_path,
        "\n\t\t->\n\t",
        path)
    
    debug_message_l4("  Creating path: ", path)
    suppressWarnings(
      dir.create(path, recursive = TRUE)
    )
  }
  
  if(clean_it){
    file.list <- list.files(path, full.names = TRUE)
    if(length(file.list)>0){
      debug_message_l4("  Deleting : ", length(file.list), " files...")
      do.call(file.remove, list(file.list))
    }  
  }
}

if(0){
  
  path <- "../ESD/step2/output/adwords-search/asd.csv"
  dir.create_if_does_not_exist(path)
  
  file_path_sans_ext(path) %>% dirname()   %>% 
    dir.create()
}