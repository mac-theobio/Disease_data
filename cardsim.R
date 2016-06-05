# Transmission function, for a given number of contacts in a particular model world. det=TRUE returns the deterministic version; cards=TRUE a stochastic version based on the detailed model; cards=FALSE a binomial approximation to the "true" stochastic version. They should be very similar, and produce qualitatively similar results
transFun <- function(contacts, S, N, det=TRUE, cards=TRUE){
	if(contacts==0) return(0)
	if(contacts>=N) return(S)
	if (det) return(contacts*S/N)
	## Pick contacts from population, and see how many are in the first S
	if (!cards) return(rbinom(1, size=S, prob=contacts/N))
	return(sum(sample(N, contacts)<=S))
}

# Simulate a stochastic epidemic, using the transFun above for the transmission step
sim <- function(R0, N=26, numSteps=10, I_0=1, det=TRUE, cards=TRUE){
	Ivec <- I <- I_0
	Svec <- S <- N-I_0
	for (j in 2:numSteps){
		trans <- transFun(R0*I, S, N, det, cards)
		I <- trans
		S <- S-trans
		if (S<0) print(c(R0*I, S, N, det, cards, trans))
		Ivec[[j]] <- I
		Svec[[j]] <- S
	}
	return(data.frame(
		timestep=1:numSteps
		, I=Ivec
		, S=Svec
	))
}

