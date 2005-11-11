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
dtm = textmatrix("landauer/", minWordLength=1)
dtm

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# make a space, reconstruct original

landauerOriginalSpace = createLSAspace(dtm, dims=dimcalc(method="raw"))
X = showLSAspace(landauerOriginalSpace)

# X should be equal to dtm (beside rounding errors)
all( (round(X,2) == dtm) == TRUE)

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# reduce dimensionality (Y shall be the recalculated 'reduced' matrix)

landauerSpace = createLSAspace(dtm, dims=2)
Y = showLSAspace(landauerSpace)
round(Y,2)

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# now read in again the landauer sample (but 
# with the vocabulary of the existing matrix)
pdocs = textmatrix("landauer/", vocabulary=rownames(dtm))

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# now calc a pseudo SVD on the basis of dtm's SVD
Y2 = foldinLSAspace(pdocs, landauerSpace)
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

