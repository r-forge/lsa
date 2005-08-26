### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### demo/lsa_landauer.r
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

library("lsa")

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# generate the files of the famous Landauer example
dir.create("landauer")
write( c("human", "interface", "computer"), file="landauer/c1")
write( c("survey", "user", "computer", "system", "response", "time"), file="landauer/c2")
write( c("EPS", "user", "interface", "system"), file="landauer/c3")
write( c("system", "human", "system", "EPS"), file="landauer/c4")
write( c("user", "response", "time"), file="landauer/c5")
write( c("trees"), file="landauer/m1")
write( c("graph", "trees"), file="landauer/m2")
write( c("graph", "minors", "trees"), file="landauer/m3")
write( c("graph", "minors", "survey"), file="landauer/m4")

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# generate doc term matrix from landauer files
dtm = dt_matrix("landauer/", minWordLength=1)
dtm

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# make an SVD
SVD = svd(dtm)
t = SVD$u # the left-sided term space
d = SVD$v # the right-sided document space
s = SVD$d # the sequence of singular values

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# reconstruct original matrix
X = t %*% diag(s) %*% t(d)
dimnames(X) = dimnames(dtm)

# X should be equal to dtm (beside rounding errors)
all( (round(X,2) == dtm) == TRUE)

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# reduce dimensionality (Y shall be the recalculated 'reduced' matrix)
k = 2
tk = t[,1:k]
dk = d[,1:k]
sk = s[1:k]
Y = tk %*% diag(sk) %*% t(dk)
dimnames(Y)=dimnames(dtm)

round(Y,2)

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# now read in again the landauer sample (but 
# with the vocabulary of the existing matrix)
pdocs = pseudo_docs("landauer/", rownames(dtm))

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# now calc a pseudo SVD on the basis of dtm's SVD
Y2 = pseudo_svd(pdocs, tk, sk)
round(Y2,2)

# Y and Y2 should be the same (as well as 
# dtm and pdocs should be equal)
all( (round(Y,2) == round(Y2,2)) == TRUE)

# calc pearson doc2doc correlation
rawCor = cor(dtm)
lsaCor = cor(Y)

# you should clearly see, that the "computer" documents (starting with "C")
# can in lsaCor be much better be differentiated from the "math" documents
# (starting with "m"). Moreover, the computer and math documents respectively
# have become more similar within their group.

round(rawCor,2)
round(lsaCor,2)

# now clean up a little.
unlink("landauer", recursive=TRUE)

