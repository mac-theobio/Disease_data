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

peak_I <- function(R0,i0=0,s0=1-i0) {
    C <- i0-1/R0*log(s0) + s0
    log(1/R0)/R0-1/R0+C
}
finalsize <- function(R0) {
  1+1/R0*suppressWarnings(lambertW(-R0*exp(-R0),maxiter=100))
}
cmpfun <- function(fun=peak_I,R0,decr=0.8) {
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

