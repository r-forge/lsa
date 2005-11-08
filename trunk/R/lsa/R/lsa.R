### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### lsa.R
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### 
### 2005-11-08: modified
###    design decision: weighting schemes will not be integrated.
###                     reason: happens before the LSA core operation / is optional
###    design decision: pre-processing also will stay part of textmatrix()
###                     for the same reasons
###    
### 2005-08-29: created.
### 

### createLSAspace (textmatrix, dims) -> LSAspace($u, $v, $d)
### showLSAspace (LSAspace) -> textmatrix
### foldinLSAspace (textmatrix, LSAspace) -> textmatrix

createLSAspace <- function( x, dims=dimcalc(method="share") ) {
    
    # do the singular value decomposition
    SVD = svd(x)
    
    # if dims is a function, then calculate the number of dims
    if (is.function(dims)) {
        dims = dims(SVD$d)
    }
    if (dims < 2) dims=2
    
    # prepare for returnation
    space = NULL
    space$tk = SVD$u[,1:dims]
    space$dk = SVD$v[,1:dims]
    space$sk = SVD$d[1:dims]
    rownames(space$tk) = rownames(x)
    rownames(space$dk) = colnames(x)
    class(space) = "LSAspace"
    
    # return the LSA space
    return ( space )
    
}

# showLSAspace: recalc a textmatrix of the 
# original format, name it and return it

showLSAspace <- function (SVD){
    Y = SVD$tk %*% diag(SVD$sk) %*% t(SVD$dk)
    rownames(Y)=rownames(SVD$tk)
    colnames(Y)=rownames(SVD$dk)
    return(Y)
}

foldinLSAspace <- function( docvecs, LSAspace ) {
    
    dqs = crossprod( t( crossprod(docvecs,LSAspace$tk) ), solve(diag(LSAspace$sk)) )
    ### alternative: dqs = crossprod( docvecs, crossprod(t(LSAspace$tk), solve(diag(LSAspace$sk))) )
    dtm = crossprod( t( crossprod(t(LSAspace$tk),diag(LSAspace$sk)) ), t(dqs) )
    
    rownames(dtm) = rownames(LSAspace$tk)
    colnames(dtm) = colnames(docvecs)
    
    environment(dtm) = new.env()
    class(dtm) = "textmatrix"
    
    return (dtm)
    
}
