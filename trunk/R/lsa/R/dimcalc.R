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
###

# return the position with which 50% share of the
# summed up singular values are reached
dimcalc_share <- function ( s, share = 0.5 ) {
    return ( max(which(cumsum(s/sum(s))<=0.5)) + 1 )
}

# calculate the slopes S={ (s(x), x ) | x E 1...n }
# where 
#       slope( s(x),x ) = (s(x2)-s(x1)) / (x2-x1)
#       <=> slope( s(x),x ) = s(x2) - s(x1)

slope <- function ( s ) {
    
    s1 = c(0,s)
    s2 = c(s,0)
    slope_s = s2 - s1
    slope_s = slope_s[2:(length(slope_s)-1)]
    return(slope_s)
    
}

# calculate the turning point k of the singular values curve
#     use the 2nd derivation of s:
#     d2(x) = slope( slope(s(x)) )
# the turning point is at the position
#     where d2(x) changes from positive values to 
#     negative values or equals 0

dimcalc_turningpoint <- function ( s ) {
    
    d2 = slope( slope(s) )
    
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
