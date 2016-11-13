library(tm)
library(stringr)
library(bigmemory)
library(RWeka)
setwd("C:\\Users\\jayavelu viswanathan\\Desktop\\Indixhack\\trainingdatafoldertxtv1")
extvalidds<-read.csv("C:\\Users\\jayavelu viswanathan\\Desktop\\Indixhack\\validtrainingdataset.csv",header=F)
extvalidds<-data.frame(extvalidds)
for (k in 1:nrow(extvalidds))
{
  filename<-paste0(as.character(extvalidds[k,1]),".txt")
  setwd("C:\\Users\\jayavelu viswanathan\\Desktop\\Indixhack\\trainingdatafoldertxtv1")
  con <- file(filename,open="r")
  doctext <- readLines(con)
  close(con)
 txt<-paste0(doctext, collapse = " ")
 txt<-gsub("(?!\\$)[[:punct:]]", " ", txt, perl=TRUE)
 txt<-gsub("[^[:alnum:]///']"," ",txt)
 txt<-gsub("[^[:alnum:] ]", "", txt)
 library(stringi)
 txt<-stringi::stri_trans_general(txt, "latin-ascii")
 extvalidds[k,3]<-txt
 extvalidds[k,4]<-extvalidds[k,2]
}
extvalidds<-extvalidds[ ,-2]
write.table(extvalidds, file = "C:\\Users\\jayavelu viswanathan\\Desktop\\Indixhack\\validtrainingdatasetextendv1.csv", append = FALSE, quote = TRUE, sep = " ",eol = "\n", na = "NA",dec = ".", row.names = F,col.names = F, qmethod = c("escape", "double"),fileEncoding = "")
txtdataforbow<-extvalidds[,2]
txtcorpus <- VCorpus(VectorSource(txtdataforbow))
txtcorpusclean <- tm_map(txtcorpus,content_transformer(tolower))
txtcorpusclean <- tm_map(txtcorpusclean, removeNumbers)
txtcorpusclean <- tm_map(txtcorpusclean,removeWords, stopwords())
txtcorpusclean <- tm_map(txtcorpusclean, stripWhitespace)
ndocs <- length(txtcorpusclean)
# ignore overly sparse terms (appearing in less than 5% of the documents)
minDocFreq <- ndocs * 0.05
# ignore overly common terms (appearing in more than 90% of the documents)
maxDocFreq <- ndocs * 0.90
ngramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 1, max = 3))}
txtcorpusdtm<- DocumentTermMatrix(txtcorpusclean, control = list(tokenize = ngramTokenizer,bounds = list(global = c(minDocFreq, maxDocFreq))))
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
}
txtcorpusdtm<- apply(txtcorpusdtm, MARGIN = 2,convert_counts)
m=as.big.matrix(x=as.matrix(txtcorpusdtm))#convert the DTM into a bigmemory object using the bigmemory package 
m=as.matrix(m)
bofdf<-data.frame(m)
bofdffull<-cbind(bofdf,as.vector(extvalidds[,3]))
write.table(bofdffull, file = "C:\\Users\\jayavelu viswanathan\\Desktop\\Indixhack\\fullvalidtrainingdatasetextendv_unibitrigram.csv", append = FALSE, quote = TRUE, sep = ",",eol = "\n", na = "NA",dec = ".", row.names = F, qmethod = c("escape", "double"),fileEncoding = "")