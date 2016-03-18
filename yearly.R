library(ggplot2)
theme_set(theme_bw(base_size=20))

tab <- read.table(input_files[[1]], header=TRUE)

print(
	ggplot(tab, aes(x=Year, y=Estimate))
	+ geom_ribbon(aes(ymin=Low, ymax=High), fill="grey90")
	+ geom_line()
	+ scale_y_continuous(limits=c(0, NA))
	+ ggtitle(title)
)
