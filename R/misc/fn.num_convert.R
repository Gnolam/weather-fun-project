debug_message_l2("[misc] adding num_convert()")

num_convert <-
  function(num_char)
    as.numeric(
      str_replace_all(
        num_char,
        regex(
          "\\,|^A\\$|^\\$"),
        ""))
