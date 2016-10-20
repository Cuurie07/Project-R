  
urlpart1="http://stat.columbia.edu/~rachel/datasets/nyt"
urlpart2=".csv"
dataframe=read.csv(url("http://stat.columbia.edu/~rachel/datasets/nyt1.csv")) #put day1 data first
for(i in 2:31){
      wholeurl=paste(paste(urlpart1,i,sep=""),urlpart2,sep="") #construct the url for different days urlpart1+i+urlpart2
      subdataframe=read.csv(url(wholeurl))
      dataframe=rbind(dataframe,subdataframe) 
    }
  # categorize
  head(dataframe)
  dataframe$agecat <- cut(dataframe$Age,c(-Inf,0,18,24,34,44,54,64,Inf))
  # view
  summary(dataframe)
  #end of problem 2a # brackets
  library(doBy)
  siterange <- function(x){c(length(x), min(x), mean(x), max(x))} 
  summaryBy(Age~agecat, data =dataframe, FUN=siterange)
  # so only signed in users have ages and genders
  summaryBy(Gender+Signed_In+Impressions+Clicks~agecat,data =dataframe)
  
  # plot for impressions
  install.packages("ggplot2")
  library(ggplot2)
  ggplot(dataframe, aes(x=Impressions, fill=agecat))+geom_histogram(binwidth=1)
  ggplot(dataframe, aes(x=agecat, y=Impressions, fill=agecat))+geom_boxplot()
  
  dataframe$hasimps <-cut(dataframe$Impressions,c(-Inf,0,Inf)) 
  summaryBy(Clicks~hasimps, data =dataframe, FUN=siterange) 
  
  #ctr plots
  ggplot(subset(dataframe, Impressions>0), aes(x=Clicks/Impressions,colour=agecat)) + geom_density()
  ggplot(subset(dataframe, Clicks>0), aes(x=Clicks/Impressions,colour=agecat)) + geom_density()
  ggplot(subset(dataframe, Clicks>0), aes(x=agecat, y=Clicks,fill=agecat)) + geom_boxplot()
  ggplot(subset(dataframe, Clicks>0), aes(x=Clicks, colour=agecat))+geom_density()
  
  # create categories
  dataframe$scode[dataframe$Impressions==0] <- "NoImps"
  dataframe$scode[dataframe$Impressions >0] <- "Imps"
  dataframe$scode[dataframe$Clicks >0] <- "Clicks"
  
  # Convert the column to a factor
  dataframe$scode <- factor(dataframe$scode)
  head(dataframe)
  
  #look at levels
  clen <- function(x){c(length(x))} 
  etable<-summaryBy(Impressions~scode+Gender+agecat,data = dataframe, FUN=clen)
  
  
  #quantitative comparison 
  library(ggplot2)
  counts <- sum(dataframe$Signed_In == 1)
  counts0 <- sum(dataframe$Signed_In == 0)
  slices <- c(counts,counts0)
  lbls <- c("Signed_In", "Not_Signed_In")
  pct <- round(slices/sum(slices)*100)
  lbls <- paste(lbls, pct) # add percents to labels 
  lbls <- paste(lbls,"%",sep="") # ad % to labels 
  pie(slices,labels = lbls, col=rainbow(length(lbls)),main="Signed_In Vs Not Signed_In")
  
  
  #Quantitative comparison of <18 females vs <18 males 
  fless <- length(which(dataframe$Age <18 & dataframe$Gender ==1))
  mless <- length(which(dataframe$Age <18 & dataframe$Gender ==0))
  library(plotrix)
  sliceval <- c(fless,mless) 
  labls <- c("Females","Males")
  pct1 <- round(sliceval/sum(sliceval)*100)
  labls <- paste(labls, pct1) # add percents to labels 
  labls <- paste(labls,"%",sep="") # ad % to labels 
  pie3D(sliceval,col=c("pink","blue"),labels=labls,main="Gender Proportion for <18 ")
  
  
  #Quantitative comparison of signed in females vs signed in males
  Fdata <- dataframe[ which( dataframe$Gender == 1 & dataframe$Signed_In == 1) , ]
  Mdata <- dataframe[which(dataframe$Gender==0 & dataframe$Signed_In ==1 ),]
  
  #for females
  ggplot(Fdata, aes(x=Fdata$Impressions,colour=Fdata$agecat)) + geom_density()
  ggplot(Fdata, aes(x=Fdata$Age, y=Fdata$Impressions,fill=Fdata$agecat)) + geom_boxplot()
  
  #for males
  ggplot(Mdata, aes(x=Mdata$Impressions,colour=Mdata$agecat)) + geom_density()
  ggplot(Mdata, aes(x=Mdata$Age, y=Mdata$Impressions,fill=Mdata$agecat)) + geom_boxplot()
  
  #data summarization
  library(doBy)
  siterange <- function(x){c(min(x), mean(x), max(x),median(x), quantile(x))} 
  summaryBy(Age~agecat, data =dataframe, FUN=siterange)
  
  #store the values in dataframe
  #newdf <- do.call(rbind, Map(data.frame, A=list1, B=list2,C=list3,D=list4))
  
  
  

 
 


