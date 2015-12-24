dat <- read.table(input_files[[1]])
par(cex=1.6)
names(dat) <- c("date", "cases")

with(dat, plot(date, cases, type="l"
	, main="Measles reports from England and Wales"
))
