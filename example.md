Frog diet analysis
========================================================

Here is an example R markdown document that integrates text written in markdown with analysis done in R. 
For example, suppose we have a dataset of frog diets in lakes with and without fish. 
We suspect that fish presence may reduce consumption of aquatic insects by frogs, because fish can eat aquatic insects before they metamorphose and become available for adult frogs foraging on the shoreline. 

Here's a picture of a cascades frog (*Rana cascadae*): 

![Cascades frog](http://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Rana_cascadae_8626.JPG/640px-Rana_cascadae_8626.JPG)

Our plan is to use generalized linear mixed models to assess how fish presence affects the consumption of aquatic prey by cascades frogs. 
We collected stomach contents of multiple frogs across multiple lakes, preserved them in ethanol, and later did our best to identify the prey items (typically to order, and at times family) in the lab. 
Here's some quick analysis, which can also be found in the file called diet_analysis.R.

Start by loading some packages.


```r
# load packages
library(lme4)
library(ggplot2)
library(effects)
```


Then load the data and look at the structure of the dataset. 


```r
# load in data
diet <- read.csv("diet.csv", header = T)
str(diet)
```

```
## 'data.frame':	262 obs. of  12 variables:
##  $ lake          : Factor w/ 7 levels "Adams","Lion",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ frog_number   : int  1 1 1 1 1 1 1 2 2 2 ...
##  $ complete_bolus: Factor w/ 2 levels "no","yes": 2 2 2 2 2 2 2 1 1 1 ...
##  $ order         : Factor w/ 17 levels "Araneae","Class Chilopoda",..: 1 1 3 4 9 12 16 1 4 4 ...
##  $ family        : Factor w/ 30 levels "Aphidoidea","Baetidae",..: 29 29 29 29 11 19 15 29 27 28 ...
##  $ length        : num  5.9 1.6 9.6 NA 9.1 NA NA 3.9 10.7 11.5 ...
##  $ frog_length   : num  66.8 66.8 66.8 66.8 66.8 66.8 66.8 48.3 48.3 48.3 ...
##  $ frog_weight   : num  24.5 24.5 24.5 24.5 24.5 24.5 24.5 8.5 8.5 8.5 ...
##  $ frog_sex      : Factor w/ 2 levels "F","M": 1 1 1 1 1 1 1 2 2 2 ...
##  $ fish          : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ aquatic       : int  0 0 0 NA 0 0 1 0 0 1 ...
##  $ frog_id       : Factor w/ 49 levels "Adams1","Adams10",..: 1 1 1 1 1 1 1 4 4 4 ...
```


Now that we know what data we're working with, we can fit a model relating fish presence/absence to the consumption of aquatic prey by frogs. 


```r
model <- glmer(aquatic ~ fish + (1 | lake) + (1 | frog_id), data = diet, family = binomial)
model
```

```
## Generalized linear mixed model fit by maximum likelihood ['glmerMod']
##  Family: binomial ( logit )
## Formula: aquatic ~ fish + (1 | lake) + (1 | frog_id) 
##    Data: diet 
##      AIC      BIC   logLik deviance 
##    255.5    268.9   -123.8    247.5 
## Random effects:
##  Groups  Name        Std.Dev.
##  frog_id (Intercept) 1.010   
##  lake    (Intercept) 0.798   
## Number of obs: 209, groups: frog_id, 45; lake, 7
## Fixed Effects:
## (Intercept)         fish  
##       0.359       -2.207
```


Finally, we can illustrate the change in the probability of aquatic prey consumption as a function of fish presence/absence. 

```r
effs <- allEffects(model)
plot(effs, rescale.axis = F, rug = F, main = "Effects of non-native trout", 
    xlab = "Trout absence or presence (0 or 1)", ylab = "Pr(consumed prey is aquatic)", 
    ylim = c(0, 1))
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 


For more details you can check out the actual paper [here](). 
