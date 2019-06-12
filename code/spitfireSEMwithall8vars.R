##creating a different working SEM for SPITFIRE

rm(list=ls())
graphics.off()


library(lavaan)
library(semPlot)

#specify model for simulating data
datamodel <- '
#measurement model
  climate =~ h20temp + 0.1*upwelling + 0.2*airtemp
  lepta =~ y1 + .3*y2 + 0.4*y3 + 0.5*y4
  nucella =~ y5 + 0.6*y6 + 0.7*y7 + 0.8*y8
#regressions
  lepta ~ 0.5*climate
  nucella ~ 0.6*climate + 0.7*lepta
#residual correlations
  h20temp ~~ upwelling
  upwelling ~~ airtemp
  y1 ~~ y2 + y3 + y4
  y2 ~~ y3 + y4
  y3 ~~ y4
  y5 ~~ y6 + y7 + y8
  y6 ~~ y7 + y8
  y7~~y8
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

#fit model to data we have generated

fit.model <- '
#measurement model
  climate =~ h20temp + upwelling + airtemp
  lepta =~ y1 + y2 + y3 + y4
  nucella =~ y5 + y6 + y7 + y8
#regressions
  lepta ~ climate
  nucella ~ climate + lepta
#residual correlations
  h20temp ~~ upwelling
  upwelling ~~ airtemp
  y1 ~~ y2 + y3 + y4
  y2 ~~ y3 + y4
  y3 ~~ y4
  y5 ~~ y6 + y7 + y8
  y6 ~~ y7 + y8
  y7~~y8
'

fit <- sem(fit.model, data=SEMdata)
summary(fit)

#visualize it

simplesyntax <- semSyntax(fit, "lavaan")
simplepath <- semPlotModel(simplesyntax)

labels <-c("Water \nTemperature", "Upwelling", "Air \nTemperature","y1","y2","y3","y4","y5","y6","y7","y8","Climate","Leptasterias","Nucella")
semPaths(fit, what="std", nodeLabels = labels)
title("SPITFIRE structural equation model")

####NOTE
#this model syntax occasionally gives the error that the model could not be identified-- need to re-run to figure out what is going on here