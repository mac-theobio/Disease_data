library(ggplot2); theme_set(theme_bw(base_size=16))
library(directlabels)
library(colorspace)

library(shellpipes)

tss <- rdsRead()

rplot <- (ggplot(tss)
  + aes(reduce,1-rel_val)
  + geom_line(aes(colour=metric),lwd=2)
  + geom_dl(method="last.bumpup",aes(label=metric,x=reduce+0.01))
  + scale_colour_discrete_qualitative()
  + scale_x_continuous(
      name="Reduction in transmission\n(strength of social distancing)",
      label=scales::label_percent(accuracy=1))
  + scale_y_reverse(
                       name="Reduction in cases",
                       label=scales::label_percent())
  + geom_vline(xintercept=c(0.2,0.4),lty=2)
  + theme(legend.position="none")
  + expand_limits(x=0.6)
)

print(rplot)
