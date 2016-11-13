# This is the third part of the code (3 of 3) submitted to Indix datamonster hackathon and three parts combined handle classification of 
# product pages from others
# This part of the code reads the text files and creates binarized bag of words representation of the text 
# otherwise called document term matrix (DTM)
# text pre-processing such as punctuation removal, stop words removal, numbers removal, spacing issues, character encoding 
# formats are taken care in this code
# once the DTM is created , the tagged labels are connected to corresponding records in the DTM and then written to a file
# the final output file fullvalidtrainingdatasetextendv_unibitrigram is used for rules generation, training and testing 
# with RIPPER algo in Weka tool. This is handled outside R
# please ensure to review the paths and set them appropriately pointing to a folder in your local inorder to execute the code

library(tm)
library(stringr)
library(bigmemory)
library(RWeka)
# reading the valid files and consolidating
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
# cleaning up the text
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
# creating document term matrix post incorporating some pre-processing
txtdataforbow<-extvalidds[,2]
txtcorpus <- VCorpus(VectorSource(txtdataforbow))
txtcorpusclean <- tm_map(txtcorpus,content_transformer(tolower))
txtcorpusclean <- tm_map(txtcorpusclean, removeNumbers)
txtcorpusclean <- tm_map(txtcorpusclean,removeWords, stopwords())
txtcorpusclean <- tm_map(txtcorpusclean, stripWhitespace)
# dimensionality reduction incorporation on dtm
ndocs <- length(txtcorpusclean)
# ignore overly sparse terms (appearing in less than 5% of the documents)
minDocFreq <- ndocs * 0.05
# ignore overly common terms (appearing in more than 90% of the documents)
maxDocFreq <- ndocs * 0.90
ngramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 1, max = 3))}
txtcorpusdtm<- DocumentTermMatrix(txtcorpusclean, control = list(tokenize = ngramTokenizer,bounds = list(global = c(minDocFreq, maxDocFreq))))
# binarizing the term frequency representation in DTM
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
}
txtcorpusdtm<- apply(txtcorpusdtm, MARGIN = 2,convert_counts)
m=as.big.matrix(x=as.matrix(txtcorpusdtm))#convert the DTM into a bigmemory object using the bigmemory package 
m=as.matrix(m)
bofdf<-data.frame(m)
# adding the labels to dtm that is already converted to dataframe
bofdffull<-cbind(bofdf,as.vector(extvalidds[,3]))
# writing the final dataset
write.table(bofdffull, file = "C:\\Users\\jayavelu viswanathan\\Desktop\\Indixhack\\fullvalidtrainingdatasetextendv_unibitrigram.csv", append = FALSE, quote = TRUE, sep = ",",eol = "\n", na = "NA",dec = ".", row.names = F, qmethod = c("escape", "double"),fileEncoding = "")