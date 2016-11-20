par(cex=1.6)

dat <- read.table(input_files[[1]], header=TRUE)

with(dat, {
	plot(Year, Total
		, main="US annual mortality rate (CDC)"
		, ylab="Deaths per 100Kp per year"
		, type = "l"
		, ylim = c(0, max(Total))
	)

	lines(Year, Infectious)

	text(1980, 1250, "All deaths")
	text(1974, 250, "Infectious disease")
})
