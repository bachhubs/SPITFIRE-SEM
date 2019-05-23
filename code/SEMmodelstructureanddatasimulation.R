library(lavaan)
help("simulateData")

#specify model
SP.model <- '
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
#talk to ben tomorrow about how to simulate data
