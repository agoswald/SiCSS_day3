#SICSS Group exercise Day 3
library(devtools)
install_github("cbail/textnets")
library(textnets)
library(dplyr)
library(Matrix)
library(tidytext)
library(stringr)
library(SnowballC)
library(reshape2)
library(phrasemachine)
library(igraph)
library(ggraph)
library(networkD3)
load(url("https://cbail.github.io/Trump_Tweets.Rdata"))
library(tidytext)
library(dplyr)
tidy_trump_tweets<- trumptweets %>%
  select(created_at,text) %>%
  unnest_tokens("word", text)
data("stop_words")

trump_tweet_top_words<-
  tidy_trump_tweets %>%
  anti_join(stop_words) %>%
  count(word) %>%
  arrange(desc(n))


trump_tweet_top_words<-
  trump_tweet_top_words[-grep("https|t.co|amp|rt",
                              trump_tweet_top_words$word),]
tidy_trump_tfidf<- trumptweets %>%
  select(created_at,text) %>%
  unnest_tokens("word", text) %>%
  anti_join(stop_words) %>%
  count(word, created_at) %>%
  bind_tf_idf(word, created_at, n)
top_tfidf<-tidy_trump_tfidf %>%
  arrange(desc(tf_idf))

top_tfidf$word[1]
tidy_trump_tfidf$word

data_network <- data.frame(cbind(tidy_trump_tfidf), stringsAsFactors = FALSE)
data_network <- as.character(data_network$tf_idf)

