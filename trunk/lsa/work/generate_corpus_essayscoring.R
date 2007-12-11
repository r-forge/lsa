# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
#   
#   create_corpus.R
#   fridolin.wild@wu-wien.ac.at, August 1st 2006
#   
# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

setwd("c:/werkstatt/lsa-package/lsa/work/")

# attention: files have to be UTF-8 otherwise
# R will crash! use corpus/convert.sh to convert
# the text files!

corpus_training = textmatrix( "corpus/corpus.6.base", stemming=FALSE, minWordLength=3, minDocFreq=1 )
corpus_essays = textmatrix( "corpus/corpus.6", stemming=FALSE, minWordLength=3, vocabulary=rownames(corpus_training) )
corpus_scores = read.table( "corpus/corpus.6.scores", row.names="V1") 

save(corpus_training, file="../data/corpus_training.rda")
save(corpus_essays, file="../data/corpus_essays.rda")
save(corpus_scores, file="../data/corpus_scores.rda")
