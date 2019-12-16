
data<-data.frame(read.csv(input_files[1], header=T))
XYs<-data.frame(read.csv(input_files[2], header=T))

startYear=1971; endYear=2000; years=startYear:endYear

# Assign country names to columns of data
countries=as.character(XYs$country)
names(data)[-1]=countries #Vector of countries
