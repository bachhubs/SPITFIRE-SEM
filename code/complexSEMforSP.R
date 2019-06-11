##creating a working SEM model for SPITFIRE

rm(list=ls())
graphics.off()


library(lavaan)
library(semPlot)

#specify model for simulating data
datamodel <- '
#measurement model
  climate =~ 1*h20temp + 0.4*upwelling + 0.27*airtemp
  lepta =~ 0.32*y1 + .314*y2
  nucella =~ .9*y3 + 0.6*y4
#regressions
  lepta ~ climate
  nucella ~ climate + lepta
#residual correlations
  h20temp ~~ upwelling
  upwelling ~~ airtemp
'

#generate data frame with 500 iterations of variables y1-y7, h20temp, upwelling, and airtemp
set.seed(1234)
SEMdata <- simulateData (datamodel, 
                         model.type = "sem", 
                         sample.nobs = 500L, 
                         return.type = "data.frame", 
                         return.fit = TRUE)

#fit specified model to data we have generated

fit.model <- '
#measurement model
  climate =~ h20temp + upwelling + airtemp
  lepta =~ y1 + y2
  nucella =~ y3 + y4
#regressions
  lepta ~ climate
  nucella ~ climate + lepta
#residual correlations
  h20temp ~~ upwelling
  upwelling ~~ airtemp
'
fit <- sem(fit.model, data=SEMdata)
summary(fit)

#visualize it

simplesyntax <- semSyntax(fit.model, "lavaan")
simplepath <- semPlotModel(simplesyntax)
semPaths(simplepath, what="paths",title=FALSE)

#The dashed line indicates fixed parameter estimates, 
#you can change that with the fixedStyle argument.
