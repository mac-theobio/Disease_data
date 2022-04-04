## ----setup,include=FALSE------------------------------------------------------
knitr::opts_chunk$set(echo=FALSE)


## ----pkgs,message=FALSE-------------------------------------------------------
library(deSolve)
library(ggplot2); theme_set(theme_bw(base_size=16))
library(tidyr)
library(dplyr)
library(purrr)
library(colorspace)
library(viridis)
library(emdbook)
library(cowplot)
library(directlabels)
## sudo apt-get install  libavfilter-dev
## sudo add-apt-repository -y ppa:cran/ffmpeg-3
## sudo apt-get update
## sudo apt-get dist-upgrade ## ????

## https://github.com/ropensci/av/issues/6


## ----params-------------------------------------------------------------------
base_R0 <- 2.5
double <- 6  ## doubling time (in days)
r <- log(2)/double
## doubling time = 6 days = 0.7/r
## r = 8.6
## b-g = 8.6
## b/g = 2
## R0*g-g=r
## g*(R0-1)=r
## g= r/(R0-1) = 8.6
base_gamma <- r/(base_R0-1)
max_time <- 40*double
base_decr <- 0.8 ## baseline decrease in R0


## ----defs---------------------------------------------------------------------
sirgrad <- function(t,y,p) {
    g <- with(as.list(c(y,p)),
    {
        c(S=-R0*gamma*S*I,
          I=gamma*I*(R0*S-1),
          R=gamma*I)
    })
    return(list(g))
}
calc_sir <- function(R0=base_R0,
                     gamma=base_gamma,
                     X0=c(S=0.995,I=0.005,R=0),
                     nt=101,
                     times=seq(0,max_time,length=nt)) {
  r1 <- ode(y=X0,
            func=sirgrad,
            times=times,
            parms=c(R0=R0,gamma=gamma))
  r2 <- (r1 %>% as.data.frame()
    %>% as_tibble()
    %>% pivot_longer(-time, names_to="var")
  )
  return(r2)
}


## ----first_sims---------------------------------------------------------------
R0vec1 <- base_R0*c(1,0.8,0.6)
lab_df <- tibble(R0=R0vec1,
                 labs=c("no control",
                        "20% control",
                        "40% control"))
names(R0vec1) <- R0vec1
all_I <- (purrr::map_dfr(R0vec1,calc_sir,.id="R0")
  %>% filter(var=="I")
  %>% mutate(R0=as.numeric(R0))
  %>% full_join(lab_df,by="R0")
)
peaks <- (all_I
  %>% group_by(R0)
  %>% filter(value==max(value))
  %>% ungroup()
)
colvec <- colorspace::qualitative_hcl(2)
peak_rng <- 0.3
(ggplot(all_I,aes(time,value,group=R0))
  + geom_line()
  + geom_dl(method="top.points",
            ## would like to parse() but see
            ## https://github.com/tdhock/directlabels/blob/6311c23a8a8c3ea1cd6549131407449356a072c7/R/ggplot2.R#L43-L45
            aes(label=labs,y=value+0.005))
  + geom_area(fill=colvec[1],alpha=0.2,position="identity")
  + labs(x="time (days)",y="proportion infected")
  + geom_segment(data=peaks,
                 aes(x=time*(1-peak_rng),
                     xend=time*(1+peak_rng),y=value,yend=value),
                 colour=colvec[2],lwd=1.5,lty="11")
)


## ----funs---------------------------------------------------------------------
peak_I <- function(R0=base_R0,i0=0,s0=1-i0) {
    C <- i0-1/R0*log(s0) + s0
    log(1/R0)/R0-1/R0+C
}
finalsize <- function(R0=base_R0) {
  1+1/R0*suppressWarnings(lambertW(-R0*exp(-R0),maxiter=100))
}
cmpfun <- function(fun=peak_I,R0=base_R0,decr=base_decr) {
  round(100*(1-fun(R0*decr)/fun(R0)))
}
peak_t <- function(R0=base_R0,gamma=1) {
  tt <- (calc_sir(R0=R0,gamma=gamma,nt=501)
    %>% filter(var=="I")
    %>% filter(value==max(value))
    %>% pull(time)
  )
  return(tt)
}
Peak_t <- Vectorize(peak_t,"R0")


## ----peak_size_calc-----------------------------------------------------------
R0vec2 <- seq(1.1,base_R0,length=101)
names(R0vec2) <- R0vec2
dd <- (bind_rows(list(peak_I=tibble(R0=R0vec2,val=peak_I(R0vec2))
                    , final_size=tibble(R0=R0vec2,val=finalsize(R0vec2))
                      ## this one is slower
                      ## ,  peak_t=tibble(R0=R0vec2,val=Peak_t(R0vec2)))
                      )
                      , .id="metric")
)


## ----mutate-------------------------------------------------------------------
dd <- (dd
  %>% mutate(reduce=1-(R0/base_R0))
  %>% group_by(metric)
  %>% mutate(rel_val=val/max(val))
)


## ----peak_size_compare_plot_2-------------------------------------------------
dd2 <- (dd
  %>% filter(metric!="peak_t")
  %>% ungroup()
  %>% mutate(metric=forcats::fct_recode(factor(metric),
                         total="final_size",peak="peak_I"))
)
(ggplot(dd2,
        aes(reduce,1-rel_val))
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


## ----animation_calc,eval=FALSE------------------------------------------------
## library(gganimate)
## all_I <- (purrr::map_dfr(R0vec2,calc_sir,.id="R0")
##   %>% filter(var=="I")
##   %>% mutate(R0=as.numeric(R0))
## )
## gg0 <- ggplot(all_I,aes(time,value))+geom_line(aes(colour=R0,group=R0)) +
##   scale_color_gradient(high="red",low="blue")+theme_classic()


## ----animate_render,eval=FALSE------------------------------------------------
## if (require("gifski") && require("av")) {
##     ## animate it over years
##   gg1 <- gg0 + gganimate::transition_states(R0,
##                       transition_length = 1, state_length = 1) +
##     gganimate::ease_aes('cubic-in-out') +
##     ggtitle('R0 = {closest_state}' )
## 
##   animate(gg1, renderer=av_renderer())
##   anim_save("R0.gif")
##   ## gg1A <- animate(gg1,renderer=ffmpeg_renderer())
## }


## -----------------------------------------------------------------------------
uniroot(function(x) peak_I(x)-0.01,interval=c(1,2))

