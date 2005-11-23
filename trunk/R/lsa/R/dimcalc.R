### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### dimcalc.r
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### 
### HISTORY
### 
### 2005-11-22
###    * removed dimcalc() function, rewrote dimcalc_* to
###      be generating functions
### 2005-08-11
###    * integrated all three functions into one joint
###      generating function. dimcalc() returns a
###      a function source to the caller which
###      contains only one parameter (the diagonal values)
###      to be executed by the calling (higher-level) function.
###      To call directly, use
###          e.g. dimcalc(method="share", share=0.3)(mydiags)
###          with mydiags being the diagonal values as a vector.
###      The original three functions will stay (maybe not forever).
### 2005-08-26
###    * removed slope / turning point sceletons (to be
###      included later, maybe)
### 2005-08-25
###    * replaced max() with length() in ndocs
###      now if the first factor is already > ndocs
###      dimcalc_ndocs returns 1 not -Inf
### 

dimcalc_share <- function ( share=0.5) {
    
    # return the position with which 50% share of the
    # summed up singular values are reached
    function ( s ) {
        return( max(which(cumsum(s/sum(s))<=share)) + 1 )
    }
    
}

dimcalc_kaiser <- function() {

    # calculate the number of singular values
    # according to the Kaiser-criterium 
    # (take all with s>1).
    function ( s ) {
        return(  max(which(s>=1)) ) 
    }

}

dimcalc_ndocs <- function(ndocs) {
    # return the position where the 
    # summed up factor values for the
    # first time exceed ndocs.

    if (missing(ndocs)) {
        stop("[dimcalc] - parameter ndocs is missing")
    }
    function ( s ) {
        return( length(which(cumsum(s)<=ndocs)) + 1 ) 
    }
}

dimcalc_raw <- function() {
    
    # only for completeness: give back the 
    # maximum number of singular values
    function ( s ) {
        return( length(s) ) 
    }
    
}

