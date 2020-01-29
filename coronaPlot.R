library(tidyverse)
library(ggplot2); theme_set(theme_bw(base_size=20))

ddcorona <- read_csv(input_files[[1]])

ddcorona <- (ddcorona
	%>% mutate(date=as.Date(date,format="%m-%d-%y")
		, time = as.numeric(date)-min(as.numeric(date))
	)
	%>% group_by(City,Province)
	%>% mutate(cases = diff(c(0,cum_cases)))
	%>% ungroup()
)

tplot <- (ggplot(ddcorona, aes(x=date, y=cases, color=Province, lty=City))
	+ geom_line()
	+ geom_point()
	+ ylab("New cases")
)

print(tplot)
print(tplot+scale_y_log10())

pplot <- (tplot 
	%+% filter(ddcorona, date<= as.Date("20-01-27",format="%y-%m-%d"))
)
print(pplot)
print(pplot+scale_y_log10())

cplot <- (ggplot(ddcorona, aes(x=date, y=cum_cases, color=Province, lty=City))
	+ geom_line()
	+ geom_point()
	+ ylab("Cumulative cases")
)

print(cplot)
print(cplot+scale_y_log10())

