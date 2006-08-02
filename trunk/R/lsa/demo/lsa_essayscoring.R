# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
#   
#   essay-scoring.R
#   fridolin.wild@wu-wien.ac.at, June 5th 2006
#   
#   Written for the tutorial at the 
#   ProLearn Summer School 2006, Bled, Slowenia
#   
# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

source("create_corpus.R")

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# CREATE SPACE

training = textmatrix( trainingsdir, stemming=FALSE, minWordLength=3, minDocFreq=1 )
weighted_training = training * gw_entropy(training)
space = lsa( weighted_training, dims=dimcalc_share(share=0.5) )


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# FOLD IN ESSAYS

essays = textmatrix( testdir, stemming=FALSE, minWordLength=3, vocabulary=rownames(training) )
weighted_essays = essays * gw_entropy(training)
lsaEssays = fold_in( weighted_essays, space )


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# TEST THEM, BENCHMARK

essay2essay = cor(lsaEssays, method="spearman")
goldstandard = c( "data6_golden_01.txt", "data6_golden_02.txt", "data6_golden_03.txt" )
machinescores = colSums( essay2essay[goldstandard, ] ) / 3

humanscores = read.table( scores, row.names="V1")

cor.test(humanscores[names(machinescores),], machinescores, exact=FALSE, method="spearman", alternative="two.sided")


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# COMPARE TO PURE VECTOR SPACE MODEL

essay2essay = cor(essays, method="spearman")
machinescores = colSums( essay2essay[goldstandard, ] ) / 3
cor.test(humanscores[names(machinescores),], machinescores, exact=FALSE, method="spearman", alternative="two.sided")

# => impressingly good!
# => in our own experiments interrater correlation 
#    was in the best case .88, but going down to
#    -0.17 with unfamiliar topics/raters
