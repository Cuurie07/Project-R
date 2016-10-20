install.packages("streamR")
install.packages("ROAuth")
install.packages("RCurl", "RJSONIO", "stringr")

library(streamR)
library(ROAuth)
library(RCurl)
library(RJSONIO)
library(stringr)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "TQ7hVnXnXZFNOGkUaGtb1x3e6"
consumerSecret <- "YIvf8FeYaIVYacZgaGwQIgEkcdLzZCYsgxLrBauQfEKWYka3uJ"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

save(my_oauth, file = "my_oauth.Rdata")

load("my_oauth.Rdata")

filterStream(file.name="trump.json", track=("trump"),tweets=100, oauth=my_oauth)
tweets <- parseTweets("trump.json", simplify = TRUE)

filterStream(file.name="obama.json", track=("obama"),tweets=100, oauth=my_oauth)
tweets1 <- parseTweets("obama.json", simplify = TRUE)


