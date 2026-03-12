
library(dplyr)
library(ggplot2); theme_set(theme_bw())

library(shellpipes)

dat <- csvRead(na=c("-", ""))
logmin <- 10

names(dat)
summary(dat)

on <- dat |> filter(prname=="Ontario")
onlate <- on |> filter(date > as.Date("2023-01-01"))

summary(on)

tplot <- (ggplot(on)
	+ aes(date, avgcases_last7)
	+ geom_line()
	+ geom_point()
	+ ylab("Average daily case reports (by week)")
	+ ylim(c(0, NA))
)

print(tplot)
print(tplot + scale_y_log10(limits=c(logmin, NA)))
print(tplot + onlate)
print(tplot + onlate + scale_y_log10(limits=c(logmin, NA)))


