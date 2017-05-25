dat <- read.table(input_files[[1]], header=TRUE)

dat <- within(dat, {
	incRate <- (100000*three_year_incidence/population)/3
})
cexs <- 1.5
par(cex.lab = cexs, cex = cexs, cex.axis = cexs)
with(dat, {
	plot(income/1000, incRate,
		xlab="Median Income (x $1000)",
		ylab="Incidence (per 100,000)", 
		ylim=c(0,max(incRate)*1.2),
		pch=19,  bty = 'n', xlim = c(0, max(income)/1000*1.2),
             main = 'Tuberculosis Notifications in USA, 1980s'
	)
})
