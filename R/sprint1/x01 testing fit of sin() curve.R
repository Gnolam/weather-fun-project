debug_message_l2("adding temperature_annual_fit_poly()")


#' Fit the annual temperature curve using polinomial approximation 
#' 
#' @describeIn 
#' This function is a 'simplified' edition for MVP
#' It fits the annual 
#' 
#' @return
#' @export
#' function returns model artifact which can be used by `predict()`` function
#'
#' @examples
#' x <- seq(1,36)
#' y_hat <- predict(fit_p14, data.frame(x=x))
#' fit_p14 <- temperature_annual_fit_poly_ref()
#' 
#' plot(x,y, xlim=c(11,24), ylim=c(14,32))
#' lines(x, predict(fit_p14, data.frame(x=x)), col='purple')
#' 
temperature_annual_fit_poly_ref <- function() {
  # Say 'Hi!'
  debug_message_l2("~> temperature_annual_fit_poly()")
  
  # Load dummy data
  dat.weather <- suppressMessages(read_csv("./io/input/weather-test-sydney.csv"))
  
  # Derive x and y from .csv file for transparency
  x <- dat.weather$i
  y <- dat.weather$`Sydney weather`
  
  # Create fit object
  fit <- lm( y~poly(x,14) )
  
  
  # ToDo: check RMSE of the resulting model
  # for the given reference .csv it is being checked manually
  
  fit
}



# Debug section -----------------------------------------------------------

if (0) {
  if (1) {
    fit_p14 <- temperature_annual_fit_poly_ref()
    
    # Load data
    dat.weather <-
      suppressMessages(read_csv("./io/input/weather-test-sydney.csv"))
    
    # Derive x and y from .csv file for transparency
    x <- dat.weather$i
    y <- dat.weather$`Sydney weather`
    y_hat <- predict(fit_p14, data.frame(x = x))
    
    plot(x, y, xlim = c(11, 24), ylim = c(14, 32))
    lines(xx, predict(fit_p14, data.frame(x = xx)), col = 'purple')
  }
}
