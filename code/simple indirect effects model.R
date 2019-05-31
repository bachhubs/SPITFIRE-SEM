###generating simplest model (indirect effect of Leptas and Nucella mediated by prey)

rm(list=ls())
graphics.off()

library(lavaan)
library(semPlot)

#specify model
simple.model <-'
              #measurementmodel
              lepta =~ 1*prey
              nucella =~ 2*prey
            
              #regression
#lepta ~ 3*nucella removed bc its not what we want for this model
              
              #residual (co)variances
              nucella ~~ lepta
'

#simulatedata
set.seed(1234)
simpledata <- simulateData(simple.model, 
                           model.type = "sem", 
                           sample.nobs = 500L, 
                           return.type = "data.frame", 
                           return.fit = TRUE)

fitsimple.model <- '
              #measurementmodel
              lepta =~ prey
              nucella =~ prey
            
              #regression
              #lepta ~ nucella
              
              #residual co(variances)
              nucella ~~ lepta
              '
fitsimple.model <- sem(fitsimple.model, data=simpledata)
summary(fitsimple.model)

#turns out you can actually bypass simulating data to visualize models... just had to figure out syntax
simplesyntax <- semSyntax(fitsimple.model, "lavaan")
simplepath <- semPlotModel(simplesyntax)
semPaths(simplepath, what="paths",title=FALSE)