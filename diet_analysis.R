# Doing some simple analysis of the cascades frog diet dataset
# for details see Joseph et al. 2011 Freshwater Biology

# load packages (install if not already installed)
require(lme4) || install.packages(lme4)
require(ggplot2) || install.packages(ggplot2) 
require(effects) || install.packages(effects) 

# load in data
diet <- read.csv("diet.csv", header=T)
str(diet)

# test whether frogs at lakes with trout have a lower probability of consuming aquatic prey
# binomial mixed model, nested random effects (individuals within lakes)
model <- glmer(aquatic ~ fish + (1|lake) + (1|frog_id), data=diet, family=binomial)
model
effs <- allEffects(model)
plot(effs, rescale.axis=F, rug=F,
     main="Effects of non-native trout", 
     xlab="Trout absence or presence (0 or 1)", 
     ylab="Pr(consumed prey is aquatic)", 
     ylim=c(0, 1))
