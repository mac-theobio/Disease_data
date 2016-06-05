library(ggplot2)
library(dplyr)
theme_set(theme_bw())

N <- 26

dat <- (read.csv(input_files[[1]])
	%>% mutate(
		trial=as.factor(trial)
		, contact_potential = I*S/N
	)
)

dat2 <- (dat
	%>% filter(R0==2)
)

shoot <- (
	ggplot(dat2, aes(x=timestep, y=I, color=trial))
	+ geom_line(lty=3)
	+  theme(legend.position="none")
)
print(shoot)

library(plyr)
stepFrame <- function(f){
	newf <- f[-nrow(f), ]
	newf$Inext <- f$I[-1]
	return(newf)
}

stepdat <- ddply(dat, . (R0, trial), stepFrame)
stepdat2 <- (stepdat
	%>% filter(R0==2)
)

step <- (
	ggplot(stepdat2, aes(x=contact_potential, y=Inext, color=trial))
	+ geom_point()
	+ theme(legend.position="none")
)
print(step)
