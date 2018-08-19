base::message("Initializing DebugMessageR...")
debug_message_reset_intent()


debug_message_start("10 init.R >>")

options(stringsAsFactors = FALSE)



# Create output folders ---------------------------------------------------
if (1) {
  fn$dir.create_if_does_not_exist(cfg$io.folder$input, clean_it = FALSE)
  fn$dir.create_if_does_not_exist(cfg$io.folder$output, clean_it = TRUE)
}


debug_message_end("10 init.R <<\n\n")