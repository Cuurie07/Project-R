require(gdata)
bk <- read.xls("rollingsales_manhattan.xls",pattern="BOROUGH")
head(bk)
summary(bk)

bk$sale.price.n<- as.numeric(gsub("[^[:digit:]]","",bk$sale.price))
count(is.na(bk$sale.price.n))
names(bk) <- tolower(names(bk))

## clean/format the data with regular expressions
bk$gross.sqft <- as.numeric(gsub("[^[:digit:]]","",bk$gross.square.feet))
bk$land.sqft <- as.numeric(gsub("[^[:digit:]]","",bk$land.square.feet))
bk$sale.date <- as.Date(bk$sale.date)
bk$year.built <- as.numeric(as.character(bk$year.built))

## do a bit of exploration to make sure there's not anything 
## weird going on with sale prices
attach(bk)
hist(sale.price.n)
hist(sale.price.n[sale.price.n>0])
hist(gross.sqft[sale.price.n==0])
detach(bk)

## keep only the actual sales
bk.sale <- bk[bk$sale.price.n!=0,]
plot(bk.sale$gross.sqft,bk.sale$sale.price.n)
plot(log(bk.sale$gross.sqft),log(bk.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
bk.homes <- bk.sale[which(grepl("FAMILY",bk.sale$building.class.category)),]
plot(log(bk.homes$gross.sqft),log(bk.homes$sale.price.n))
bk.homes[which(bk.homes$sale.price.n<100000),][order(bk.homes[which(bk.homes$sale.price.n<100000),]$sale.price.n),]

## remove outliers that seem like they weren't actual sales
bk.homes$outliers <- (log(bk.homes$sale.price.n) <=5) + 0
bk.homes <- bk.homes[which(bk.homes$outliers==0),]
plot(log(bk.homes$gross.sqft),log(bk.homes$sale.price.n))

#formatting the date column
bk$sale.date <- as.Date(bk$sale.date, format="%Y-%m-%d")

#check if numeric columns are numeric
sapply(bk, class)

#other interesting plots
plot(bk$tax.class.at.present, type="h",main="tax class at present",xlab="tax categories",ylab="Frequency",ylim=c(0, 40000),col=c("red","green","yellow","pink","blue"))
bk$tax.class.at.time.of.sale <- factor(bk$tax.class.at.time.of.sale)
plot(bk$tax.class.at.time.of.sale,type="h",main="tax class at time of sale",xlab="tax categories",ylab="Frequency",ylim=c(0,40000),col=c("red","green","yellow","pink","blue"))


#total unit vs residential unit
bk$total.units <- as.numeric(bk$total.units)
bk$residential.units <- as.numeric(bk$residential.units)
ggplot(data=bk, aes(x=bk$residential.units, y=bk$total.units, fill=bk$total.units)) + geom_bar(colour="red", fill="blue", width=.8, stat="identity") + guides(fill=FALSE) +xlab("Residential unit") + ylab("Total units") +ggtitle("Residential vs Total")
bk$commercial.units <- as.numeric(bk$commercial.units)
ggplot(data=bk, aes(x=bk$commercial.units, y=bk$total.units, fill=bk$total.units)) + geom_bar(colour="blue", fill="blue", width=.8, stat="identity") + guides(fill=FALSE) +xlab("Commercial unit") + ylab("Total units") +ggtitle("Commercial vs Total")


