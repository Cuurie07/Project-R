#Loading tweet jsons
library(twitteR)
library(RCurl) 
library(rjson)
library(jsonlite)
data4 <- fromJSON("valid.json")
# Remove duplicates
data4 <- data4[!duplicated(data4[c("id")]),]

#load rollingsales data

urlpart1="rollingsales_"
list=c("bronx","manhattan","queens","statenisland")
urlpart2=".xls"
bk <- read.xls("rollingsales_brooklyn.xls",pattern="BOROUGH")
for(i in 1:4){
  wholeurl=paste(paste(urlpart1,list[[i]],sep=""),urlpart2,sep="") #construct the url for different days urlpart1+i+urlpart2
  subdataframe=read.xls(wholeurl,pattern="BOROUGH")
  bk=rbind(bk,subdataframe) 
}

#load trulia csv

url1="data"
url2=".csv"
trul <-read.csv("data1.csv")
for(j in 2:15){
  wurl=paste(paste(url1,j,sep=""),url2,sep="") #construct the url for different days urlpart1+i+urlpart2
  subdata=read.csv(wurl)
  trul=rbind(trul,subdata) 
}

#analysis on data4
s<-sum(grepl("\\<buy\\>|\\<apartment\\>", data4$text_en))
t<-sum(grepl("\\<rent\\>|\\<apartment\\>", data4$text_en))

library(plotrix)
sl <- c(s,t) 
lab <- c("Buy apartment","Rent apartment")
p <- round(sl/sum(sl)*100)
lab <- paste(lab, p) # add percents to labels 
lab <- paste(lab,"%",sep="") # ad % to labels 
pie3D(sl,col=c("green","yellow"),labels=lab,main="No of customers willing to buy vs willing to rent")

#analysis using trulia

income <-read.csv("h08.csv")
subincome <-income[6:112,]

subincome$salary <- as.numeric(gsub("[^[:digit:]]","",subincome$X))

# Define 2 vectors
cars <- c(1, 3, 6, 4, 9)
trucks <- c(2, 5, 4, 5, 12)

# Graph using a y axis that ranges from 0 to 12
plot(subincome$salary, type="o", col="blue", ylim=c(0,100000))

# Graph with red dashed line and square points
trul$Price <-as.numeric(trul$Price)
lines(trul$Price, type="o", pch=22, lty=2, col="red")




