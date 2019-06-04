rm(list=ls())
graphics.off()

##vignette for R package lavaan
library(lavaan)

#help page for example dataset
#?PoliticalDemocracy

#specify model (see pg. 9 of lavaan documentation for visual representation)
model <- '
#measurement model
  ind60 =~ x1 + x2 + x3
  dem60 =~ y1 + y2 + y3 + y4
  dem65 =~ y5 + y6 + y7 + y8
#regressions
  dem60 ~ ind60
  dem65 ~ ind60 + dem60
#residual correlations
  y1 ~~ y5
  y2 ~~ y4 + y6
  y3 ~~ y7
  y4 ~~ y8
  y6 ~~ y8
'

#see model and results
fit <- sem(model, data=PoliticalDemocracy)
summary(fit, standardized=TRUE)

#adding in the means of observed variables
fit <- sem(model, data=PoliticalDemocracy, meanstructure=TRUE)
summary(fit, standardized=TRUE)

#visualize it
library(semPlot)

simplesyntax <- semSyntax(fit, "lavaan")
simplepath <- semPlotModel(simplesyntax)
semPaths(simplepath, what="paths",title=FALSE)

#The dashed line indicates fixed parameter estimates, 
#you can change that with the fixedStyle argument.

##Simulating data using parameters from model fit (above)

sim.model<-'
        #measurement model
  ind60 =~ 1.000*x1 + 2.180*x2 + 1.819*x3
  dem60 =~ 1.000*y1 + 1.257*y2 + 1.058*y3 + 1.265*y4
  dem65 =~ 1.000*y5 + 1.186*y6 + 1.280*y7 + 1.266*y8
#regressions
  dem60 ~ 1.483*ind60
  dem65 ~ 0.572*ind60 + 0.837*dem60
#residual correlations
  y1 ~~ 0.624*y5
  y2 ~~ 1.313*y4 + 2.153*y6
  y3 ~~ 0.795*y7
  y4 ~~ 0.348*y8
  y6 ~~ 1.356*y8
  '

set.seed(1234)
simpledata <- simulateData(sim.model, 
                           model.type = "sem", 
                           sample.nobs = 500L, 
                           return.type = "data.frame", 
                           return.fit = TRUE)
#does it recover the original variances?

model <- '
#measurement model
  ind60 =~ x1 + x2 + x3
  dem60 =~ y1 + y2 + y3 + y4
  dem65 =~ y5 + y6 + y7 + y8
#regressions
  dem60 ~ ind60
  dem65 ~ ind60 + dem60
#residual correlations
  y1 ~~ y5
  y2 ~~ y4 + y6
  y3 ~~ y7
  y4 ~~ y8
  y6 ~~ y8
'

#see model and results
fit <- sem(model, data=simpledata)
summary(fit, standardized=TRUE)


