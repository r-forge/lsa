### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### mean_max()
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### 
### returns the means correlation of the best docs
### and the maximum correlation among the best docs
###
### usage:
###       mm = mean_max( cor(docvectors), c("bla.txt","bla2.txt") )
### return:
###       mm$mean :: average correlation with the best docs
###       mm$max :: maximum correlation among the best docs
### 
### //fw. 26.1.2004
### 

mean_max <- function ( corPD, best ) {
    
    mm = NULL
    mm$mean = vector(mode="numeric",length(corPD[1,]))
    mm$max = vector(mode="numeric",length(corPD[1,]))
    mm$max[1:length(mm$max)] = -1
    # mm$maxname = vector(mode="character", length(corPD[1,]))
    
    i = 0
    while (i<length(corPD[1,])) {
        i = i + 1
        n = 0
        for (b in best) {
            n = n + 1
            mm$mean[i] = mm$mean[i] + corPD[b,i]
            if ( corPD[b,i] >= mm$max[i] ) {
                mm$max[i] = corPD[b,i]
                # mm$maxname = b
            }
        }
        mm$mean[i] = mm$mean[i] / n
    }
    
    return(mm)

}
