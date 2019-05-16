#multilevel SEM vignette in lavaan (pt 39 of documentation)

#specifying model for two levels
model <- '
  level: 1
  fw =~ y1 + y2 + y3
  fw ~ x1 + x2 + x3
  level: 2
  fb =~ y1 + y2 + y3
  fb ~ w1 + w2
'
#fit model to demo dataset: Demo.twolevel
fit <- (sem(model=model, data= Demo.twolevel, cluster="cluster"))
summary(fit)

#inspecting the intra-class correlations post model fitting
lavInspect(fit, "icc")

#to see unrestricted (h1) within and between means and covariances
lavInspect(fit, "h1")

#if you don't have a model in mind for level 2
#can specify a saturated level by adding all variances and covariances of the endogenous variables
model <- '
  level: 1
    fw =~ y1 + y2 + y3
    fw ~ x1 + x2 + x3
  level: 2
    y1 ~~ y1 + y2 + y3
    y2 ~~ y2 + y3
    y3 ~~ y3
'

fit <- (sem(model=model, data= Demo.twolevel, cluster="cluster"))
summary(fit)