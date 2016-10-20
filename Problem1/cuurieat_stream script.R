

#illustration of stream api
install.packages("streamR")
install.packages("ROAuth")
install.packages("twitteR", "RCurl", "RJSONIO", "stringr")

## Now we load the packages
library(streamR)
library(ROAuth)
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- ""
consumerSecret <- ""
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)

## run this line and go to the URL that appears on screen
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))


## now you can save oauth token for use in future sessions with twitteR or streamR
save(my_oauth, file = "my_oauth.Rdata")

load("my_oauth.Rdata")

#function to actually scrape Twitter that mention a given keyword
## in real time, as they are being published, with the 'filterStream' command
filterStream(file.name="obama_tweets.json", track=c("obama", "biden"), 
             tweets=100, oauth=my_oauth)

#function to actually scrape Twitter
filterStream( file.name="/Users/anjali/Desktop/tweets_test.json",
              track="twitter", tweets=1000, oauth=my_oauth, timeout=10, lang='en' )


#Once it has finished, we can open it in R as a data frame with the
## "parseTweets" function
tweets.df <- parseTweets("/Users/anjali/Desktop/DIC/tweets/tweets_test.json", simplify = TRUE)

## It's also possible to collect a random sample of tweets. That's what
## the "sampleStream" function does:

sampleStream(file.name="tweets_random.json", timeout=30, oauth=my_oauth)

## Finally, here's how you can capture the most recent tweets (up to 3,200)
## of any given user (in this case, @nytimes)

getTimeline(filename="tweets_nytimes.json", screen_name="nytimes", 
            n=1000, oauth=my_oauth, trim_user="false")


#next we look at twitteR
## first let's look at an individual call
library(devtools)
library(twitteR)
library(RCurl) 
library(rjson)
res3 <- fromJSON("/Users/anjali/Desktop/DIC/tweets/tweet3.json")

# combine them both into one data.frame
finalr <-rbind(finalr,res3)
dim(finalr)
View(finalr)

# Remove duplicates
finalr <- finalr[!duplicated(finalr[c("id")]),]




install.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!
#install_github("twitteR", username="geoffjentry")
library(devtools)
library(twitteR)
library(RCurl) 

#SSL Certificate
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

# API URLs
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"

# API Keys from https://apps.twitter.com/app/new 
apiKey <- ""
apiSecret <- ""
accessToken <- ""
accessSecret <- ""
setup_twitter_oauth(apiKey, apiSecret, accessToken, accessSecret)

query <- "Obama,kuwait"
query <- unlist(strsplit(query,","))
tweets = list()

for(i in 1:length(query)){
  res1<-searchTwitter(query[i],n=100)
  tweets <- c(tweets,res1)
  tweets <- unique(tweets)
}

df <- do.call("rbind", lapply(tweets, as.data.frame))

View(df)
# Remove duplicates
mydf <- mydf[!duplicated(mydf[c("id")]),]















