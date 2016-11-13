# This is the second part of the code (2 of 3) submitted to Indix datamonster hackathon and three parts combined handle classification of 
# product pages from others
# The code reads each of the html files from trainingdatafolder directory and converts it into text file 
# then write the text files to trainingdatafoldertxtv1 directory
# the text file name is same as html file execept that then extension of the file is now .txt
# please ensure to review the paths and set them appropriately pointing to a folder in your local inorder to execute the code

htmlToText <- function(input, ...) {
  ###---PACKAGES ---###
  require(RCurl)
  require(XML)
  
  
  ###--- LOCAL FUNCTIONS ---###
  # Determine how to grab html for a single input element
  evaluate_input <- function(input) {    
    # if input is a .html file
    if(file.exists(input)) {
      char.vec <- readLines(input, warn = FALSE)
      return(paste(char.vec, collapse = ""))
    }
    
    # if input is html text
    if(grepl("</html>", input, fixed = TRUE)) return(input)
    
    # if input is a URL, probably should use a regex here instead?
    if(!grepl(" ", input)) {
      # downolad SSL certificate in case of https problem
      if(!file.exists("cacert.perm")) download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.perm")
      return(getURL(input, followlocation = TRUE, cainfo = "cacert.perm"))
    }
    
    # return NULL if none of the conditions above apply
    return(NULL)
  }
  
  # convert HTML to plain text
  convert_html_to_text <- function(html) {
    doc <- htmlParse(html, asText = TRUE)
    text <- xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue)
    return(text)
  }
  
  # format text vector into one character string
  collapse_text <- function(txt) {
    return(paste(txt, collapse = " "))
  }
  
  ###--- MAIN ---###
  # STEP 1: Evaluate input
  html.list <- lapply(input, evaluate_input)
  
  # STEP 2: Extract text from HTML
  text.list <- lapply(html.list, convert_html_to_text)
  
  # STEP 3: Return text
  text.vector <- sapply(text.list, collapse_text)
  return(text.vector)
}
# read each html / xml file from trainingdatafolder directory on the file system
library(RCurl)
library(XML)
filenames <- list.files("/home/sunil/Desktop/indixhack/trainingdatafolder", full.names=F)
for (i in filenames) {
setwd("/home/sunil/Desktop/indixhack/trainingdatafolder")
# assign input (could be a html file, a URL, html text, or some combination of all three is the form of a vector)
input <- i
# calling the htmlToText custom function with file name as the parameter
txt <- htmlToText(input)
# post-processing the output returned by htmlToText custom function
txt<-paste(txt, collapse = "\n")
outfilename<-paste0(input,".txt")
# writing the created text file to trainingdatafoldertxtv1 directory
setwd("/home/sunil/Desktop/indixhack/trainingdatafoldertxtv1")
writeLines(txt,outfilename)
}

