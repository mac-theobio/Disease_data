# Disease_data
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: ewmeas.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk

##################################################################

Sources += $(wildcard *.R)

###############

# England and Wales measles time series from Ben Bolker's data site.
# http://ms.mcmaster.ca/~bolker/measdata.html

ewmeas.ssv: 
	wget -O $@ "http://ms.mcmaster.ca/~bolker/measdata/ewmeas.dat"
 
ewmeas.Rout: ewmeas.ssv ewmeas.R
	$(run-R)

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
