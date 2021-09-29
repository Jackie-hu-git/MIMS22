# This file: simple_examples_in_R
# October, 2020
# This is just a short R script to show you how to 
# do the most common things with an existing 
# dataset in R. We will use a small subset of data from the 
# General Social Survey (GSS). This particular GSS survey 
# was run in the mid 1990's. 

# Remember these critical best practices whenever
# you build your own R scripts:
# 1) Always *comment* what you are doing (one comment for
#    a group of related commands is fine).
# 2) Do not save over your original dataset/dataframe
#    with your new recodes. This can easily lead to 
#    disaster. After recoding and dealing with
#    missing values, etc... always save your new data 
#    to a new filename if you are going to save the 
#    dataframe when you are done! NEVER overwrite 
#    your *original* dataset! Also, remember that 
#    unless you specifically save your working 
#    dataframe, any recodes and changes to missing 
#    values that you make will not be saved anywhere.
#    Thus, you should always keep track with 
#    well-commented scripts and clear dataframe 
#    saving conventions.

# First, we need to load our data.
# Please note that since my data is in the same folder 
# as this script, I do not need a longer pathname when 
# I load my data:
load("GSS.Rdata")

# Viewing the GSS data in R
View(GSS)

# Just viewing our dataframe is not enough information alone.
# There are a lot of variables that have clear value labels, 
# but many are not so clear. For any secondary data such as 
# the GSS, we should look at the official codebook so that 
# we know how variables are coded. We are especially interested 
# in knowing about 'missing' codes! Here is a link
# to the main site for GSS: http://gss.norc.org/get-documentation
# We also recommend the searchable "GSS data explorer" website, 
# which allows you to quickly search for individual variable 
# names to view their codebook info:
# https://gssdataexplorer.norc.org/

# For example, use the gss data explorer to search for the 
# 'sibs' variable that is in our dataframe. What does -1 
# mean for this variable? What about 98 and 99?

# We can also get a summary of our dataframe. Together, 
# a codebook + this summary info is what we need in order
# to understand our data before we conduct any analyses.

summary(GSS)

### MISSING DATA ###

# One of the most important things we do in
# data preparation is work
# with missing data. First, lets look at a 
# factor variable in our dataset, "news"

# We know it is a factor by checking:
is.factor(GSS$news)

# Now lets just get a table of the responses for
# this particular variable.

table(GSS$news)

# I know from looking at the codebook (linked in above
# comments) that "NAP" means "Not Applicable", and 
# is one type of missing value used by the GSS. 
# We have several cases
# with this value, so we can set them to NA, which 
# we know is R's way of dealing with 'missing' values.
# There is another tricky thing going on here, which
# is that some of the responses are labeled with the 
# text "NA" but that doesnt mean that R knows that
# they are actually missing. In other words, "NA" and
# "NAP" from the GSS responses are just text strings until
# we explicitly tell R that these are missing codes
# in a way that R can understand!

GSS$news[GSS$news == "NAP"] = NA
GSS$news[GSS$news == "NA"] = NA

# just checking to be sure we did it right...

table(GSS$news)

# this just shows whether each case is missing or not.
# we see several 'true' responses, which are our NA's.
is.na(GSS$news)

# Now, let's look at the mean for the numeric 
# variable "tvhours". If we check the codebook,
# we will see that this should be *hours that the 
# person watches tv per day*. Does the value
# make sense?

mean(GSS$tvhours)

# Hmm... since we are careful scientists, maybe 
# we should look for missing value codes in our
# numeric variable before moving along.

hist(GSS$tvhours, breaks=50)

# Hmmm.. wonder why there is someone with almost 100 hours of 
# tv viewing per DAY... that cannot be right... and it isnt.
# It turns out that "99" is a very common missing code!

table(GSS$tvhours)
GSS$tvhours[GSS$tvhours==99] = NA

# Now, let's try that again...

hist(GSS$tvhours, breaks=50)

table(GSS$tvhours)

# Let's look at a boxplot while we are at it.
# Remember that a boxplot shows us the median,
# interquartile range, and outliers outside the
# majority of cases.

boxplot(GSS$tvhours)

# Also, note that if you try to take the mean when
# you have declared (NA) missing values, it just wont work:
mean(GSS$tvhours)

# We just have to tell R to not count the 
# declared (NA) missing values:
mean(GSS$tvhours, na.rm=TRUE)

# We can also look at tvhours for different groups. 
# Let's look at the means by race first.

by(GSS$tvhours, GSS$race, mean, na.rm=TRUE)

# I can also look at the variance of tvhours by race.

by(GSS$tvhours, GSS$race, var, na.rm=TRUE)

### RECODING VARIABLES ###

# Another thing that we do before analyzing or exploring
# data is recode variables that we want to use later. The
# cardata package (companion to applied regression data sets)
# has a recode function that is really helpful. 

# Let's install the carData package first (you only have to do
# this one time)

install.packages('carData')

# Now we can use it:
library (carData)

# Now we can do some recodes in a very easy way. Here is
# an example of a very common recode. We will take a factor
# variable (news) and create a single dummy variable for
# those who read news everyday (1) vs everyone else (0).
# We will call our new variable 'everydaynews'.

table(GSS$news)
GSS$everydaynews = ifelse(GSS$news == "Everyday", 1, 0)

# Note that if we take the mean, this is now interpretable
# as the percent of those who read news everyday. Keep in 
# mind that the percentage refers to the 'true' category,
# which is the group coded as 1. 
mean(GSS$everydaynews, na.rm=T)

# Now we can turn our numeric dummy variable into a factor
# variable where 0 = not every day and 1 = everyday. Just
# so we understand what is going on, lets go through this
# one step at a time:

GSS$everydaynews = factor(GSS$everydaynews)

# now we check the levels, which should just be numeric.
levels(GSS$everydaynews)

# here, we apply meaningful lables to our factors.
levels(GSS$everydaynews) = c("not everyday","everyday")

# then, we check the levels again to make sure it worked right.
levels(GSS$everydaynews)

# Now we can use our new factor. Let's get the mean of 
# tvhours by those who read news everyday and those who
# do not read news everyday:

by(GSS$tvhours, GSS$everydaynews, mean, na.rm=TRUE)

# Let's do something cool with ggplot. We have already done 
# histograms in R, but we can do much prettier versions 
# with ggplot. Let's make sure to download and then add
# the library first, which is called 'ggplot2'.

install.packages('ggplot2')
library(ggplot2)

# First, lets look at age...
mean(GSS$age)

#Perhaps we should just check it visually...
hist(GSS$age)

# In fact, we should check the online codebook and see for sure:
# https://gssdataexplorer.norc.org/variables/vfilter

# Dealing with those pesky missing codes...
GSS$age[GSS$age == 99] = NA
mean(GSS$age, na.rm=T)

# Now we can do some cool graphics. Lets do a density plot
# of age, but overlay by our 'everydaynews' binary variable.
# Please note that I must use the na.omit when I declare the data,
# otherwise ggplot will actually plot the NA's as a 3rd category!

# Create a new dataframe with only rows with non-missing values for age 
# and everydaynews. This is one way to be completely sure that you're
# correctly accounting for missing values in the data you supply to the
# chart function. 
GSS2 = na.omit(GSS[, c('age', 'everydaynews')])
ggplot(GSS2, aes(x=age, fill=everydaynews)) + geom_density(alpha=.2)

# Now, lets do boxplots of age, by everydaynews:
ggplot(GSS2, aes(x=everydaynews, y=age)) + geom_boxplot()


# Finally, lets do a recode where we make a binary variable out 
# of age. In this case, if someone has an age greater than the mean
# they will be coded as 'high age', and mean or lower than the mean as 
# 'low age'.

GSS$high_age = GSS$age > mean(GSS$age, na.rm = TRUE)

# Now we can take the mean of our binary variable.
# Since this is a dummy variable, the value we get
# is the proportion of those coded 1, or those with
# greater than the mean age in our sample.
mean(GSS$high_age, na.rm=T)

# If we want, we can convert this numeric binary into a factor variable:
GSS$high_age = factor(GSS$high_age)
levels(GSS$high_age) = c("low age","high age")
table(GSS$high_age)

# That is all for now!