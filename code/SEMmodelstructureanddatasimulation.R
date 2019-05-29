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
<<<<<<< HEAD
            y1 ~~ y2
=======
            y1 ~~ y2'
#talk to ben tomorrow about how to simulate data
>>>>>>> 220a83f4359cd01d2b8742e2126558af1b5b6aac
