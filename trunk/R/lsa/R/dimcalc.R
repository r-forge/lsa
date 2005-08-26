### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### dimcalc.r
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### 
### HISTORY
### 
### 2005-08-25
###    * replaced max() with length() in ndocs
###      now if the first factor is already > ndocs
###      dimcalc_ndocs returns 1 not -Inf
### 2005-08-26
###    * removed slope / turning point sceletons (to be
###      included later, maybe)
### 

# return the position with which 50% share of the
# summed up singular values are reached
dimcalc_share <- function ( s, share = 0.5 ) {
    return ( max(which(cumsum(s/sum(s))<=0.5)) + 1 )
}

# calculate the number of singular values
# according to the Kaiser-criterium 
# (take all with s>1).

dimcalc_kaiser <- function (s) {
    return( max(which(s>=1)) )
}

# return the position where the 
# summed up factor values for the
# first time exceed ndocs.

dimcalc_ndocs <- function ( s, ndocs ) {
    return( length(which(cumsum(s)<=ndocs)) + 1 )
}
