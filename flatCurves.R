## ----pkgs,message=FALSE-------------------------------------------------------
library(ggplot2); theme_set(theme_bw(base_size=16))
library(colorspace)
library(directlabels)
library(dplyr)

library(shellpipes)
startGraphics()

loadEnvironments()

colvec <- colorspace::qualitative_hcl(2)
peak_rng <- 0.3
dloffset <- 0.3

tplot <- (ggplot()
  + aes(time,apk,group=R0)
  + geom_line()
  + geom_dl(method="top.points", aes(label=labs,y=apk+dloffset))
  + geom_area(fill=colvec[1],alpha=0.2,position="identity")
  + labs(x="time (days)",y="Active cases per kp")
  + geom_segment(data=peaks,
                 aes(x=time*(1-peak_rng),
                     xend=time*(1+peak_rng),y=apk,yend=apk),
                 colour=colvec[2],lwd=1.5,lty="11")
)

print(tplot %+% (all_I %>% filter(R0==max(R0))))
print(tplot %+% all_I)
