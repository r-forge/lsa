### cosine.r

cosvecs <- function(v1,v2) {
  return(sum(v1*v2) / (sqrt(sum(v1^2))*sqrt(sum(v2^2))))
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
