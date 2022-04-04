library(dplyr)
library(emdbook)

library(shellpipes)

loadEnvironments()

base_R0 <- 2.5

R0vec2 <- seq(1.1,base_R0,length=101)
names(R0vec2) <- R0vec2
dd <- (bind_rows(list(peak_I=tibble(R0=R0vec2,val=peak_I(R0vec2))
                    , final_size=tibble(R0=R0vec2,val=finalsize(R0vec2))
                      ## this one is slower
                      ## ,  peak_t=tibble(R0=R0vec2,val=Peak_t(R0vec2)))
                      )
                      , .id="metric")
)

dd <- (dd
  %>% mutate(reduce=1-(R0/base_R0))
  %>% group_by(metric)
  %>% mutate(rel_val=val/max(val))
  %>% filter(metric!="peak_t")
  %>% ungroup()
  %>% mutate(metric=forcats::fct_recode(factor(metric)
    , total="final_size",peak="peak_I")
  )
)

rdsSave(dd)
