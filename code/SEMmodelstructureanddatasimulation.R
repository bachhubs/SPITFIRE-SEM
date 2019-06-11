#working through an earlier version of the conceptual model, attempting to troubleshoot problems with simulateData function

rm(list=ls())
graphics.off()

library(lavaan)
help("simulateData")


#specify model
SP.model <- '
            #measurement model
            lepta =~ 1*x1 + 2*x2 + 3*x3 + 4*x4
            nucella =~ 5*x1 + 6*x2 + 7*x3 + 8*x4
            climate =~ 9*y1 + 10*y2
            #regressions
          lepta ~ 1*climate
            nucella ~ 2*climate
            lepta ~ 3*nucella
            #residual (co)variances
            y1 ~~ y2'

#simulating/generating data
set.seed(1994)
SEMdata <- simulateData (SP.model, 
                         model.type = "sem", 
                         sample.nobs = 500L, 
                         return.type = "data.frame", 
                         return.fit = TRUE)

SP.fitmodel<- '
            #measurement model
            lepta =~ x1 + x2 + x3 + x4
            nucella =~ x1 + x2 + x3 + x4
            climate =~ y1 + y2
            #regressions
          lepta ~ climate
            nucella ~ climate
            lepta ~ nucella
            #residual (co)variances
            y1 ~~ y2'
fit <- sem(SP.fitmodel, data=SEMdata)
summary(fit)

#added 6/3/19: visualizing this model as it is parameterized in SP.fitmodel
simplesyntax <- semSyntax(SP.fitmodel, "lavaan")
simplepath <- semPlotModel(simplesyntax)
semPaths(simplepath, what="paths",title=FALSE)

#it's wild and definitely not what i wanted this to look like!

#scraps- from working with Ben on model fit + parameterization
#got the code working (generates data, not latent variables. Have to fit data to compare back to specified parameter vals. in o.g. model)
if(0){
  #population moments
  fitted(sem(SP.model))
  
  #sample moments
  round(cov(SEMdata),6)
  round(colMeans(SEMdata),6)
  
  #fit model
  fit <- sem(SP.model, data=SEMdata)
  summary(fit)
  
  #visualizing model using semplot
  semPaths(SP.model, title=FALSE)
  
}
