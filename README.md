# indix_data_monster

Below is the pipeline of the algorithm -

1) Tagged 286 samples to be used as training data

2) Extracted all the elements of html code of the training data samples into individual text files

3) pre-processed the text for cleanup - removed punctuations, stop words, redundant spaces, numbers etc.

4) created document term matrices (DTMs) with varied ngrams (unigrams, bigrams, trigrams, uni-bi and trigrams)

5) binarized the term frequency in the DTMs

6) Created final training dataset consisting 286 documents represented with bag of words and with final column representing the class of the document.

7) Fed the datasets to RIPPER algorithm to generate rules and compute the performance metric (accuracy) using the 10 fold cross validation technique.

rules-* are the rules generated along with performance measurements. 

code files & sequence of execution :

step 1) trainingdataextraction.R 

step 2) createtextfilesfromhtml.R

step 3) createfulltrainingdataset_ngrams.R

step 4) run JRIP in Weka 

In the interest of time and to keep the scope realistic for this hackathon day, we have not used website html / xml features for rules generation but it is purely based on text extracted from webpages. However, we identified such features -

1) large number of table grids.

2) multiple currency symbols

3) Number of images 

4) number of sellers listed on the page etc. 
