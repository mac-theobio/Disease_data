library(deSolve)
library(tidyr)
library(dplyr)

library(shellpipes)

loadEnvironments()

base_R0 <- 2.5
double <- 6  ## doubling time (in days)
r <- log(2)/double
base_gamma <- r/(base_R0-1)
max_time <- 40*double
base_decr <- 0.8 ## baseline decrease in R0

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
  %>% mutate(apk=1000*value)
  %>% full_join(lab_df,by="R0")
)

peaks <- (all_I
  %>% group_by(R0)
  %>% filter(value==max(value))
  %>% ungroup()
)

summary(all_I %>% mutate_if(is.character, as.factor))

saveVars(all_I, peaks)
