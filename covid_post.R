
library(dplyr)
library(ggplot2); theme_set(theme_bw())

library(shellpipes)

dat <- csvRead()

names(dat)

on <- dat |> filter(prname=="Ontario")
onlate <- on |> filter(date > as.Date("2023-01-01"))

tplot <- (ggplot(on)
	+ aes(date, avgcases_last7)
	+ geom_line()
	+ geom_point()
	+ ylab("Average daily case reports (by week)")
	+ ylim(c(0, NA))
)

print(tplot)
print(tplot %+% onlate)

