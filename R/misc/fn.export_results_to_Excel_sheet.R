debug_message_l2("[misc] adding export_results_to_Excel_sheet() v1.1")

export_results_to_Excel_sheet <- function(
  wb,
  sheet_name,
  variable
) {
  debug_message_l4(" ~> export_results_to_Excel_sheet(", sheet_name ,")")
  addWorksheet(
    wb,
    sheet_name,
    gridLines = FALSE,
    tabColour = "#4F81BD")

  writeDataTable(wb, sheet_name, x = variable)  
}

