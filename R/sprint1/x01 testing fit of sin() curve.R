debug_message_l2(" testig fit sin() curves")

weather <- read_csv("./io/input/weather-test-sydney.csv")

x <- weather$i
y <- weather$`Sydney weather`

fit_p5 <- lm( y~poly(x,5) )
fit_p9 <- lm( y~poly(x,9) )
fit_p14 <- lm( y~poly(x,14) )


xx <- seq(1,36)

#lines(xx, predict(fit4, data.frame(x=xx)), col='purple')
#yy <- predict(fit4, data.frame(x=x))

plot(x,y, xlim=c(11,24), ylim=c(14,32))
lines(x, predict(fit_p5, data.frame(x=x)), col='blue')
lines(x, predict(fit_p9, data.frame(x=x)), col='purple')
lines(x, predict(fit_p14, data.frame(x=x)), col='black')


# example -----------------------------------------------------------------

lm.1 <- lm(y ~ x + I(x^2) + I(x^3) + I(x^4) )
lm.s <- step(lm.1)
lines(x, predict(lm.s, data.frame(x=x)), col='yellow')




dat = data.frame(
  x1 = x,
  x2 = x,
  x3 = x,
  x4 = x,
  x5 = x
)

lm.2 <- lm(y ~ dat$x1 + cos(dat$x2)*dat$x3)


plot(x,y, xlim=c(11,24), ylim=c(14,32))
lines(x, predict(lm.2, data.frame(x=dat)), col='red')
