### 
### testing routines for LSA package
### 

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# routines for get/set/delTriples

print("[triples] - starting with tests.")

myTextMatrix = matrix(2,2,3);
colnames(myTextMatrix) = c("c1","c2","c3");
rownames(myTextMatrix) = c("dog","cat");
environment(myTextMatrix) = new.env();
class(myTextMatrix) = "textmatrix";

setTriple(myTextMatrix, "c1", "has_category", 15)
setTriple(myTextMatrix, "c1", "has_category", 11)
setTriple(myTextMatrix, "c3", "has_category", 20)
setTriple(myTextMatrix, "c2", "has_category", 20)
setTriple(myTextMatrix, "c1", "has_category", 20)

errors = NULL

errors = append(errors, all( (getTriple(myTextMatrix)[[1]] == as.vector(c("1", "1", "3", "2", "1"))) == TRUE))
errors = append(errors, all( (getTriple(myTextMatrix)[[2]] == as.vector(rep("has_category", 5))) == TRUE))
errors = append(errors, all( (getTriple(myTextMatrix)[[3]] == as.vector(c("15","11","20","20","20"))) == TRUE))

errors = append(errors, all( (getTriple(myTextMatrix, "c1")[[1]] == as.vector(rep("has_category",3))) == TRUE))
errors = append(errors, all( (getTriple(myTextMatrix, "c1")[[2]] == as.vector(c("15","11","20"))) == TRUE))

errors = append(errors, getTriple(myTextMatrix, "c2")[[1]][1] == "has_category")
errors = append(errors, getTriple(myTextMatrix, "c2")[[2]][1] == "20")

errors = append(errors, all( (getTriple(myTextMatrix, "c1", "has_category") == c("15","11","20")) ))

delTriple(myTextMatrix, "c1", "has_category", 11)

errors = append(errors, all( (getTriple(myTextMatrix, "c1")[[1]] == as.vector(rep("has_category",2))) == TRUE))
errors = append(errors, all( (getTriple(myTextMatrix, "c1")[[2]] == as.vector(c("15","20"))) == TRUE))

setTriple(myTextMatrix, "c1", "has_category", 17)

errors = append(errors, all( (getTriple(myTextMatrix)[[1]] == as.vector(c("1", "3", "2", "1", "1"))) == TRUE))
errors = append(errors, all( (getTriple(myTextMatrix)[[2]] == as.vector(rep("has_category", 5))) == TRUE))
errors = append(errors, all( (getTriple(myTextMatrix)[[3]] == as.vector(c("15","20","20","20","17"))) == TRUE))

if (any(errors == FALSE)) {
    stop("[triples] - fatal error");
} else {
    print("[triples] - testing went fine.")
}

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# routines for textmatrix

print("[textmatrix] - starting with tests.")

# create landauer example with files

td = tempdir()
dir.create(td)
write( c("human", "interface", "computer"), file=paste(td,"/c1", sep=""))
write( c("survey", "user", "computer", "system", "response", "time"), file=paste(td,"/c2", sep=""))
write( c("EPS", "user", "interface", "system"), file=paste(td,"/c3", sep=""))
write( c("system", "human", "system", "EPS"), file=paste(td,"/c4", sep=""))
write( c("user", "response", "time"), file=paste(td,"/c5", sep=""))
write( c("trees"), file=paste(td,"/m1", sep=""))
write( c("graph", "trees"), file=paste(td,"/m2", sep=""))
write( c("graph", "minors", "trees"), file=paste(td,"/m3", sep=""))
write( c("graph", "minors", "survey"), file=paste(td,"/m4", sep=""))

errors = NULL

# test normal matrix
dtm = textmatrix(td)
errors = append(errors, all( rownames(dtm) == c("computer", "human",  "interface", "response", "survey", "system", "time", "user", "trees", "graph", "minors")))
errors = append(errors, all( colnames(dtm) == c("c1","c2","c3","c4","c5","m1","m2","m3","m4") ))

# test with reduced vocabulary (replaces former function pseudo_docs)
dtm2 = textmatrix(td, vocabulary = rownames(dtm)[-(3:7)])
errors = append(errors, all( rownames(dtm2) == c("computer", "human",  "user", "trees", "graph", "minors")))
errors = append(errors, all( colnames(dtm2) == c("c1","c2","c3","c4","c5","m1","m2","m3","m4") ))

# test with stemming
dtm = textmatrix(td, stemming=TRUE, language="english")
errors = append(errors, all( rownames(dtm) == c("comput", "human", "interfac", "respons", "survey", "system", "time", "user", "tree", "graph", "minor")))

# test with stopping
write( c("the", "das", "minor", "die", "it"), file=paste(td,"/stopwords", sep=""))

data(stopwords_en)
dtm = textmatrix(td, stopwords=stopwords_en, minDocFreq=1, minWordLength=1)
errors = append(errors, all( rownames(dtm) == c("computer", "human", "interface", "response", "survey", "system", "time", "user", "eps", "trees", "graph", "minors", "das", "die", "minor")))

data(stopwords_de)
dtm2 = textmatrix(td, stopwords=stopwords_de, minDocFreq=1, minWordLength=1)
errors = append(errors, all( rownames(dtm2) == c("computer", "human", "interface", "response", "survey", "system", "time", "user", "eps", "trees", "graph", "minors", "it", "minor", "the" )))

unlink(paste(td,"/stopwords",sep=""), recursive=TRUE)

# now clean up a little.
unlink(td, recursive=TRUE)

# test for word order sensitivity

td = tempdir()
dir.create(td)
td1 = paste(td,"test1",sep="/");
dir.create(td1)
write( c("word4", "word3", "word2"), file=paste(td1,"/c1", sep=""))
write( c("word1", "word4", "word2"), file=paste(td1,"/c2", sep=""))
td2 = paste(td,"test2",sep="/");
dir.create(td2)
write( c("word1", "word2", "word3"), file=paste(td2,"/c1", sep=""))
write( c("word1", "word2", "word3"), file=paste(td2,"/c2", sep=""))
dtm1 = textmatrix(td1)
dtm2 = textmatrix(td2, vocabulary=rownames(dtm1))
errors = append(errors, length(rownames(dtm1)) == length(rownames(dtm2)))
errors = append(errors, rownames(dtm1) == rownames(dtm2))
unlink(td, recursive=TRUE)

if (any(errors == FALSE)) {
    stop("[textmatrx] - fatal error");
} else {
    print("[textmatrix] - testing went fine.")
}

