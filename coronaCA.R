library(ggplot2); theme_set(theme_bw())
library(dplyr)
library(shellpipes)

startGraphics()

dat <- csvRead()

summary(dat)

ON <- filter(dat, Province=="ON")

allp <- (ggplot(dat)
	+ aes(Date, newConfirmations, color=Province)
	+ geom_line()
)

print(allp)
print(allp + scale_y_log10(limits=c(10, NA)))

startGraphics(desc="ON")

onp <- (ggplot(ON)
	+ ggtitle("ON coronavirus")
	+ ylab("New confirmations")
	+ aes(Date, newConfirmations)
	+ geom_line()
)

print(onp)
print(onp + scale_y_log10(limits=c(10, NA)))

