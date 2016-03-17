library(ggplot2)
theme_set(theme_bw())

tab <- read.table(input_files[[1]], header=TRUE)

print(
	ggplot(tab, aes(x=Year, y=Estimate))
	+ geom_line()
	+ scale_y_continuous(limits=c(0, NA))
)
