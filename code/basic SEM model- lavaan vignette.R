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


