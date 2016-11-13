filenames <- list.files("/home/sunil/Desktop/indixhack/HTMLPage-Classifier-Dataset/datasetall", full.names=F)
filenames<-data.frame(filenames)
validfilelist<-read.csv("/home/sunil/Desktop/indixhack/sunilindix.csv", header=F)
validfilelist<-data.frame(validfilelist[,-2])
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
for(k in 1:nrow(validtds))
{
  file.copy(as.character(validtds[k,1]), "/home/sunil/Desktop/indixhack/trainingdatafolder")
}