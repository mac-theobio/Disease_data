## This is Disease_data

current: target
-include target.mk

# include makestuff/perl.def

######################################################################

# Content

vim_session:
	bash -cl "vmt"

## coronaCA.Rout: coronaCA.R
## coronaCA.ON.Rout: coronaCA.R

######################################################################

## Current Canadian data 2024 Mar 25 (Mon)

covid_post.Rout: covid_post.R covid_post.csv
	$(pipeR)

Ignore += covid_post.csv
covid_post.csv:
	wget -O $@ "https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv"

######################################################################

Sources += $(wildcard *.R *.mkd *.pl)

# England and Wales measles time series from Ben Bolker's data site.
# http://ms.mcmaster.ca/~bolker/measdata.html

## See also outputs/ewmeas.ssv
Ignore += ewmeas.ssv
ewmeas.ssv: 
	wget -O $@ "http://ms.mcmaster.ca/~bolker/measdata/ewmeas.dat"
 
ewmeas.Rout: ewmeas.ssv ewmeas.R
	$(wrapR)

##################

### JD TB income stuff from George Cauthen's floppy disk
### This is for three specific years in the 1980s

Sources += $(wildcard *.tsv)

tbincome.Rout: tbincome.tsv tbincome.R
	$(wrapR)

##################

### SPECTRUM "data" from UNAIDS site

Sources += HIV_incidence_all.csv PLWH_all.csv

UNAIDS.mkd:

# For now, just try to pull the worldwide data from these scary files

Ignore += *.tab
PLWH_all.world.tab: PLWH_all.csv worldUN.pl
%.world.tab: %.csv worldUN.pl
	$(PUSH)

HIV_incidence_all.world.yearly.Rout.pdf: HIV_incidence_all.world.tab HIV_incidence_all.world.vars.Rout yearly.R
%.yearly.Rout: %.vars.Rout %.tab yearly.R
	$(run-R)

##### Epidemic cards

Sources += cards_2016.csv

cards.Rout: cards_2016.csv cardsim.Rout cards.R
	$(run-R)

####### US mortality plot 

Sources += us2000.txt
us2000.Rout: us2000.txt us2000.R

######################################################################

## Africa data from synchrony paper; this has a theobio wiki that should be updated

rsread.Rout: rsinc.csv rscoords.csv rsread.R
rsincplot.Rout: rsread.Rout rsincplot.R

######################################################################

## coronavirus, Mike Li spreadsheet

Sources += $(wildcard corona.csv)

## coronaPlot.Rout-0.pdf: coronaPlot.R
coronaPlot.Rout: coronaPlot.R corona.csv
	$(pipeR)

Ignore += coronaCA.csv
## del coronaCA.csv ## to reload ##
coronaCA.csv:
	wget -O $@ "https://raw.githubusercontent.com/wzmli/COVID19-Canada/master/git_push/clean.Rout.csv"

coronaCA.Rout: coronaCA.R coronaCA.csv
	$(pipeR)

Ignore += coronaCA.*.pdf
coronaCA.ON.pdf: coronaCA.Rout ;
## coronaCA.Rout-2.pdf: coronaCA.R

pipeRoutdesc += coronaCA

######################################################################

## Flatten the curve
## Oops! This directory was supposed to be for data curation; fix after class is done 2022 Apr 03 (Sun)

## bolker.R: bolker.rmd

flatFuns.Rout: flatFuns.R
	$(wrapR)
flatSims.Rout: flatSims.R flatFuns.rda
	$(pipeR)
flatSimPlots.Rout: flatSimPlots.R flatSims.rda
	$(pipeR)
flatResponse.Rout: flatResponse.R flatFuns.rda
	$(pipeR)
flatResponsePlots.Rout: flatResponsePlots.R flatResponse.rds
	$(pipeR)

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/pdfpages.mk
## -include makestuff/rmd.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
