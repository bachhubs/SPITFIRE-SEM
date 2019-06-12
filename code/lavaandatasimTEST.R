#testing data simulation function with original lavaan vignette

rm(list=ls())
graphics.off()

##vignette for R package lavaan
library(lavaan)

#specify model
model <- '
#measurement model
  ind60 =~ x1 + 0.2*x2 + 0.3*x3
  dem60 =~ y1 + 0.5*y2 + 0.6*y3 + 0.7*y4
  dem65 =~ y5 + 0.9*y6 + 1*y7 + 1.1*y8
#regressions
  dem60 ~ 0.1*ind60
  dem65 ~ 0.4*ind60 + 0.8*dem60
#residual correlations
  y1 ~~ y5
  y2 ~~ y4 + y6
  y3 ~~ y7
  y4 ~~ y8
  y6 ~~ y8
'

#simulate dataset with above parameters

set.seed(1234)
SEMdata <- simulateData (model, 
                         model.type = "sem",
                         sample.nobs = 1000L, 
                         return.type = "data.frame", 
                         return.fit = TRUE
                         )
#looking at dataset
head(SEMdata)

#sample moments
round(cov(SEMdata),11)
round(colMeans(SEMdata),11)

#fit specified model to data we have generated

fit.model <- '
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
fit <- sem(fit.model, data=SEMdata)
summary(fit)

#this works and returns latent variable estimates that are close to what we originally specified
