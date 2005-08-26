### cosine.r
###
### 2005-08-26:
###   * rewrote cosvecs function to crossprod
### 

cosvecs <- function(v1,v2) {
  return ( crossprod(v1*v2) / (sqrt(crossprod(v1))*sqrt(crossprod(v2))) )
}

cosine <- function( m ) {
    f = colnames( m )
    co = array(0,c(length(f),length(f)))
    dimnames(co) = list(f,f)
    for (i in f) {
        for (j in f) {
            co[i,j] = cosvecs(m[,i], m[,j])
        }
    }
    return (co)
}
