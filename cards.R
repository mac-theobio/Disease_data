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

sim2 <- sim(R0=2) %>% mutate(trial="1")
sim2x <- sim(R0=2.3) %>% mutate(trial="1")

shoot <- (
	ggplot(dat2, aes(x=timestep, y=I, color=trial))
	+ geom_line(lty=3)
	+ theme(legend.position="none")
)
print(shoot)
print(shoot
	+ geom_line(data=sim2, size=1.6)
)
print(shoot
	+ geom_line(data=sim2, size=1.6)
	+ geom_line(data=sim2x, size=1.6)
)

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

print(geom_abline())
print(step+geom_abline(slope=2))
print(step+geom_abline(slope=2)+geom_abline(slope=2.2))
