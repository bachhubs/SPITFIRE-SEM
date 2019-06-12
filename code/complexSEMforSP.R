##creating a working SEM for SPITFIRE

rm(list=ls())
graphics.off()


library(lavaan)
library(semPlot)

#specify model for simulating data
datamodel <- '
#measurement model
  climate =~ h20temp + 0.1*upwelling + 0.2*airtemp
  lepta =~ y1 + .3*y2
  nucella =~ y3 + 0.4*y4
#regressions
  lepta ~ 0.5*climate
  nucella ~ 0.6*climate + 0.7*lepta
#residual correlations
  h20temp ~~ upwelling
  upwelling ~~ airtemp
'

#generate data frame with 500 iterations of variables y1-y7, h20temp, upwelling, and airtemp
set.seed(1234)
SEMdata <- simulateData (datamodel, 
                         model.type = "sem", 
                         sample.nobs = 5000L, 
                         return.type = "data.frame", 
                         return.fit = TRUE)

round(cov(SEMdata),7)
round(colMeans(SEMdata),7)
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
semPaths(simplepath, what="paths",whatLabels="est",title="SPITFIRE structural equation model")

#The dashed line indicates fixed parameter estimates, 
#you can change that with the fixedStyle argument.
