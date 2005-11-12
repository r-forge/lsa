### cosine.R
###
### 2005-11-09:
###   * bugfix cosvecs
###   * integrated cosvecs into cosine by doing type dependant processing
### 2005-08-26:
###   * rewrote cosvecs function to crossprod
### 

cosine <- function( x, y=NULL ) {
    
    if ( is.matrix(x) && is.null(y) ) {
        
        co = array(0,c(ncol(x),ncol(x)))
        
        f = colnames( x )
        dimnames(co) = list(f,f)
        
        for (i in 1:ncol(x)) {
            for (j in 1:ncol(x)) {
                co[i,j] = cosine(x[,i], x[,j])
            }
        }
        
        return (as.matrix(co))
        
    } else if ( is.vector(x) && is.vector(y) ) {
        
        return ( crossprod(x,y) / ( sqrt(crossprod(x)) * sqrt(crossprod(y)) ) )
        
    } else {
        
        stop("argument mismatch. Either one matrix or two vectors needed as input.")
        
    }
    
}
