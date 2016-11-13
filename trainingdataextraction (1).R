# This is the first part of the code (1 of 3) submitted to Indix datamonster hackathon and three parts combined handle classification of 
# product pages from others
# The code in here copies the tagged files listed in sunilindix.csv to a sub directory
# please ensure to review the paths and set them appropriately pointing to a folder in your local inorder to execute the code
filenames <- list.files("/home/sunil/Desktop/indixhack/HTMLPage-Classifier-Dataset/datasetall", full.names=F)
#dataset all is a directory where all sample files are copied to prior to runing this algo
filenames<-data.frame(filenames)
validfilelist<-read.csv("/home/sunil/Desktop/indixhack/sunilindix.csv", header=F) #sunilindix.csv is the tagged dataset file
validfilelist<-data.frame(validfilelist[,-2])
# identifying the union of files in datasetall and the listing in sunilindix.csv
foundflag<-0
for (file in 1:nrow(filenames))
{
for(validfile in 1:nrow(validfilelist))
{
  if(grepl(as.character(filenames[file,1]),as.character(validfilelist[validfile,1]))==TRUE)
  {
    foundflag<-1
    break
  }
}
  if(foundflag==1)
  {
    filenames[file,2]<-foundflag
    foundflag<-0
  }
  else
  {
    filenames[file,2]<-0
  }
}
x <-filenames[filenames$V2==1,]
y<-unique(validfilelist[validfilelist$V1 %in% x$filenames,])
write.table(y, file = "/home/sunil/Desktop/indixhack/validtrainingdataset.csv", append = FALSE, quote = TRUE, sep = ",",eol = "\n", na = "NA",dec = ".", row.names = F,col.names = F, qmethod = c("escape", "double"),fileEncoding = "")
validtds<-read.csv("/home/sunil/Desktop/indixhack/validtrainingdataset.csv", header=F)
View(validtds)
setwd("/home/sunil/Desktop/indixhack/HTMLPage-Classifier-Dataset/datasetall")
# move the flagged files to the trainingdatafolder directory
for(k in 1:nrow(validtds))
{
  file.copy(as.character(validtds[k,1]), "/home/sunil/Desktop/indixhack/trainingdatafolder")
}