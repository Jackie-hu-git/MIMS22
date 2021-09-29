### T-tests to compare two means in R

# In this script, we'll practice using t-tests to
# see if two means are significantly different from
# each other. In this case, we are looking at two
# groups, Trustworthy and Less Trustworthy Countries
# based on the "corruption perceptions index" (CPI) 
# score. Remember that we used this same data in 
# our Chi-Square Test of Independence example.
# 
# In our t-test, the metric variable we will 
# compare between the two groups is the gross domestic 
# product (GDP), a primary indicator of a country's economy.

# Our hypothesis is that more trustworthy countries have 
# higher GDP than corrupt countries.

# Use the Countries dataset
load("Countries2.Rdata")

summary(Countries)

# load the car package and ggplot. I also add "lsr" which adds
# the ability to get cohen's d effect sizes.
library(car)
library(ggplot2)
library(lsr)

# 1. Let's look at gdp between the 
#corrupt and trustworthy Country groups.
#First, lets just look at GDP (gross 
# domestic product).

hist(Countries$gdp)

# It is really skewed! For variables like income, 
# and in this case GDP, this type of *known* skew 
# is often easily corrected with a log transformation. 
# Note that I can rely on the CLT to conduct my t-test, 
# so I DO NOT have to take the log of GDP 
# because of any particular assumption. However, this particular
# correction is very is common in economic analyses b/c 
# income/gdp/etc are always positively skewed. So, it makes 
# sense that we used the common log transformation here. 
# Let's try and see:

Countries$loggdp = log10(Countries$gdp)

hist(Countries$loggdp)
# It certainly looks a lot less skewed here!


# Now let's just see if we think there is a 
# mean difference between groups.
by(Countries$loggdp, Countries$high_cpi, mean, na.rm = TRUE)

# But is this statistically significant?
# We need to check our assumptions and then run the test.

# Exploring our Data and Checking Assumptions:

# Let's look at the distributions of the two groups using
# boxplots:
plot = ggplot(Countries, aes(x=high_cpi, y=loggdp))
plot + geom_boxplot()

# Just a reminder that we can use the na.omit feature 
# with the specific column names specified in order to look 
# at this same boxplot without the NA's for high_cpi and loggdp.

plot = ggplot(na.omit(Countries[, c('high_cpi', 'loggdp')]), aes(x=high_cpi, y=loggdp))
plot + geom_boxplot()

# From the qqplot, it's not clear if loggdp is 
# normally distributed. Its not a perfect line on the diagonal,
# so its not perfectly normal (which is fine, it doesnt
# break any assumptions here)
qqnorm(Countries$loggdp)

# While the log of GDP is clearly less skewed than 
# GDP alone would have been, the Shapiro test 
# lets us test normality just to see. Again, its
# not a problem that it is non-normal b/c we have
# a sample > 30 and we are relying on the 
# CLT for our t-test below.
shapiro.test(Countries$loggdp)

# Finally, lets check to see if our variances are equal
# between the two different groups (using Levene's test)
# Note that since my high_cpi variable is not a factor,
# I will go ahead and convert it to a factor.

# So, we first create a factor variable form our character
# variable (high_cpi).
class(Countries$high_cpi)
Countries$cpi_factor <- factor(Countries$high_cpi)
levels(Countries$cpi_factor)

# Run Levene's Test:
leveneTest(Countries$loggdp, Countries$cpi_factor, center=median)

# Running the t-test:

# Because we have a large sample size, so we can rely on the 
# central limit theorem and use a regular t.test (as 
# opposed to a non-parametric test which one might use on 
# a very small sample).

# Look in ?t.test to understand the syntax of the "~" symbol. 
# The "formula" argument requires the form lhs ~ rhs: where
# "lhs is a numeric variable giving the data values and rhs 
# a factor with two levels giving the corresponding groups." 

# I am going to save the results of my test to "ind.t.test" 
# so that I can refer to it again below.
# Notice that the t.test runs the Welch's Two Sample 
# t-test that assumes non-homogeneous variances by default.
# Remember from lecture that Welch's t-test is valid to run 
# whether our variances are equal or not.
ind.t.test<-t.test(Countries$loggdp ~ Countries$cpi_factor, Countries)
ind.t.test


# Also note that the default t-test is always 2-tailed.
# If we want to run a one-tailed test, we could do the 
# quick calculation ourselves (dividing the p-value
# of the two-tailed test by 2... do you remember why?)
# Alternatively, we could tell R to run a one-tailed test. 
# For example, we could run the test with the alternative
# hypothesis that the diff in means is greater than 0 or less 
# than zero. Knowing which to pick depends on knowing 
# how your variable was coded. In the following example, 
# our factor variable has "Corrupt" as the first category, 
# and "Trustworthy" as the second category. So, I logically 
# choose to test 'less', which means that we think that gdp 
# will be less for "Corrupt" countries than for "Trustworthy" ones.

levels(Countries$cpi_factor)

t.test(Countries$loggdp ~ Countries$cpi_factor, alternative='less',
       data=Countries)


## Effect Size.
## Ok, now let's go back to our original 2-sided test that
# we saved as "ind.t.test" and compute effect sizes.

# We can compute the effect size correlation (r) based on the
# results of our t-test. Here, I am following the same
# procedure in the book, p. 385. Note that we are
# creating new variables, t and df, based on the
# values from our recent t-test (ind.t.test)

t<-ind.t.test$statistic[[1]]
df<-ind.t.test$parameter[[1]]

# effect size correlation, interpreted like a
# standard correlation coefficient:
r<-sqrt(t^2/(t^2+df))
#output the result, but round to 3 decimals.
round(r, 3)

# We can also computer cohen's d by using
# the lsr package which we installed earlier.

cohensD(Countries$loggdp ~ Countries$cpi_factor)

# Look at the table from our lecture notes as a reminder for
# how to interpret Cohen's d effect sizes. We can also
# get a visual look at the overlap (and non-overlap) between
# the two groups:

ggplot(na.omit(Countries[, c('loggdp','cpi_factor')]), 
       aes(x=loggdp, fill=cpi_factor)) + geom_density(alpha=.5)


# The End!
