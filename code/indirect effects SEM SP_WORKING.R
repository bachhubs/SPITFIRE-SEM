####simplifying SEM structure to attempt to fix issue with paramaterization in previous code


rm(list=ls())
graphics.off()

library(lavaan)
library(semPlot)

if(0){
  #specify model


SP.model <-'
            #measurement model
            lepta =~ 1*x1 + 2*x2 + 3*y1
            nucella =~ 4*x1 + 5*x2 + 6*y1
            
            #regressions
            lepta ~ 3*nucella + 4*prey
            nucella ~ 5*prey

            #residual (co)variances
            x1 ~~ x2'

#simulating/generating data
set.seed(1234)
SEMdata <- simulateData (SP.model, 
                         model.type = "sem", 
                         sample.nobs = 500L, 
                         return.type = "data.frame", 
                         return.fit = TRUE)

SP.fitmodel<- '
#measurement model
            lepta =~ x1 + x2 + y1
            nucella =~ x1 + x2 + y1
            
            #regressions
            lepta ~ nucella + prey
            nucella ~ prey

            #residual (co)variances
            x1 ~~ x2'

fit <- sem(SP.fitmodel, data=SEMdata)
summary(fit)


#notes May 30 2019 DF is still -4... didn't work and information matrix could not be inverted...

#trying to visualize it anyway just for kicks

#calling syntax for our model (after it has been fit to the data we simulated)
SP.fitmodel2 <- semSyntax(fit, "lavaan")

#now we have to tell R to visualize the object as a formal class semPlotModel
SPsemPath <- semPlotModel(SP.fitmodel2, fixed.x=FALSE)
#need to look into why the fixed.x=false requirement exists... remove this and re-run to see warning message

#actually visualizing my beautiful little model
semPaths(SPsemPath, what="paths", title=FALSE)
}

#one issue is that I made "y1" and "prey" two different parameters (they were supposed to be the same)
#attempting to fix

SP.model <-'
            #measurement model
            lepta =~ 1*x1 + 2*x2 + 3*y1
            nucella =~ 4*x1 + 5*x2 + 6*y1
            
            #regressions
            lepta ~ 3*nucella + 4*y1
            nucella ~ 5*y1

            #residual (co)variances
            x1 ~~ x2'

#simulating/generating data
set.seed(1234)
SEMdata <- simulateData (SP.model, 
                         model.type = "sem", 
                         sample.nobs = 500L, 
                         return.type = "data.frame", 
                         return.fit = TRUE)

SP.fitmodel<- '
            #measurement model
            lepta =~ x1 + x2 + y1
            nucella =~ x1 + x2 + y1
            
            #regressions
            lepta ~ nucella + y1
            nucella ~ y1

            #residual (co)variances
            x1 ~~ x2'

fit <- sem(SP.fitmodel, data=SEMdata)
summary(fit)

visualizefit <- semSyntax(fit, "lavaan")
SPsemPath <- semPlotModel(visualizefit)
#seems to have fixed fixed.x=FALSE problem from above

semPaths(SPsemPath, what="paths", title=FALSE)

#looking better, but still has issues (site and lat affecting each other... haven't seen this incorporated into other path diagrams and I think I need to remove)
#generating simplest model (indirect effect of Leptas and Nucella mediated by prey) in sep. script

