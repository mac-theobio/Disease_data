# Disease_data
### Hooks for the editor to set the default target
current: target
target pngtarget pdftarget vtarget acrtarget: us2000.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md sub.mk LICENSE.md
include sub.mk

-include $(ms)/perl.def

##################################################################

Sources += $(wildcard *.R *.mkd *.pl)

###############

# England and Wales measles time series from Ben Bolker's data site.
# http://ms.mcmaster.ca/~bolker/measdata.html

ewmeas.ssv: 
	wget -O $@ "http://ms.mcmaster.ca/~bolker/measdata/ewmeas.dat"
 
ewmeas.Rout: ewmeas.ssv ewmeas.R
	$(run-R)

##################

### SPECTRUM "data" from UNAIDS site

Sources += HIV_incidence_all.csv PLWH_all.csv

UNAIDS.mkd:

# For now, just try to pull the worldwide data from these scary files

PLWH_all.world.tab: PLWH_all.csv worldUN.pl
%.world.tab: %.csv worldUN.pl
	$(PUSH)

# Hook
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

####### Ebola data (moving from Dropbox/academicWW/Ebola_math/WHO/liberia150429.npc.RR

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
