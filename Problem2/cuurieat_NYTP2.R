#read from csv file 
data1 <- read.csv("nyt1.csv")
# categorize
data1$agecat <- cut(data1$Age,c(-Inf,0,18,24,34,44,54,64,Inf))
# view
summary(data1)
#end of problem 2a

# brackets
install.packages("doBy")
library(doBy)
siterange <- function(x){c(length(x), min(x), mean(x), max(x))} 
summaryBy(Age~agecat, data =data1, FUN=siterange)
# so only signed in users have ages and genders
summaryBy(Gender+Signed_In+Impressions+Clicks~agecat,data =data1)


# plot for impressions
install.packages("ggplot2")
library(ggplot2)
ggplot(data1, aes(x=Impressions, fill=agecat))+geom_histogram(binwidth=1)
ggplot(data1, aes(x=agecat, y=Impressions, fill=agecat))+geom_boxplot()


data1$hasimps <-cut(data1$Impressions,c(-Inf,0,Inf)) 
summaryBy(Clicks~hasimps, data =data1, FUN=siterange) 

#ctr plots
ggplot(subset(data1, Impressions>0), aes(x=Clicks/Impressions,colour=agecat)) + geom_density()
ggplot(subset(data1, Clicks>0), aes(x=Clicks/Impressions,colour=agecat)) + geom_density()
ggplot(subset(data1, Clicks>0), aes(x=agecat, y=Clicks,fill=agecat)) + geom_boxplot()
ggplot(subset(data1, Clicks>0), aes(x=Clicks, colour=agecat))+geom_density()

# create categories
data1$scode[data1$Impressions==0] <- "NoImps"
data1$scode[data1$Impressions >0] <- "Imps"
data1$scode[data1$Clicks >0] <- "Clicks"

# Convert the column to a factor
data1$scode <- factor(data1$scode)
head(data1)

#look at levels
clen <- function(x){c(length(x))} 
etable<-summaryBy(Impressions~scode+Gender+agecat,data = data1, FUN=clen)


#quantitative comparison 
library(ggplot2)
counts <- sum(data1$Signed_In == 1)
counts0 <- sum(data1$Signed_In == 0)
slices <- c(counts,counts0)
lbls <- c("Signed_In", "Not_Signed_In")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(slices,labels = lbls, col=rainbow(length(lbls)),main="Signed_In Vs Not Signed_In")


#Quantitative comparison of <18 females vs <18 males 
fless <- length(which(data1$Age <18 & data1$Gender ==1))
mless <- length(which(data1$Age <18 & data1$Gender ==0))
library(plotrix)
sliceval <- c(fless,mless) 
labls <- c("Females","Males")
pct1 <- round(sliceval/sum(sliceval)*100)
labls <- paste(labls, pct1) # add percents to labels 
labls <- paste(labls,"%",sep="") # ad % to labels 
pie3D(sliceval,col=c("pink","blue"),labels=labls,main="Gender Proportion for <18 ")


#Quantitative comparison of signed in females vs signed in males
Fdata <- data1[ which( data1$Gender == 1 & data1$Signed_In == 1) , ]
Mdata <- data1[which(data1$Gender==0 & data1$Signed_In ==1 ),]

#for females
ggplot(Fdata, aes(x=Fdata$Impressions,colour=Fdata$agecat)) + geom_density()
ggplot(Fdata, aes(x=Fdata$Age, y=Fdata$Impressions,fill=Fdata$agecat)) + geom_boxplot()

#for males
ggplot(Mdata, aes(x=Mdata$Impressions,colour=Mdata$agecat)) + geom_density()
ggplot(Mdata, aes(x=Mdata$Age, y=Mdata$Impressions,fill=Mdata$agecat)) + geom_boxplot()

#data summarization
library(doBy)
siterange <- function(x){c(min(x), mean(x), max(x),median(x), quantile(x))} 
summaryBy(Age~agecat, data =data1, FUN=siterange)


