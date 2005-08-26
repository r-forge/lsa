### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### pseudo_dtm v0.2
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### dependencies: library("RStem")
### 
### 2005-08-25: added "\\[|\\]|\\{|\\}" to gsub
### 

pseudo_docs <- function( docdir, termlist, stemming=FALSE, language="german" ) {
    
    # docdir: directory pointing to the files to be parsed
    # termlist: list of allowed terms
    # dtm: original doc-term-matrix (no weighting applied!)
    
    doclist = dir(docdir)
    
    dtm = vector( mode="numeric", length(termlist)*length(doclist) );
    wc = length(termlist)
    
    for (n in doclist) {
        
        zz = file(paste(docdir, n, sep=""),"rt")
        q = strsplit( gsub("[[:space:]]+", " ", gsub( "\\.|:|\\(|\\)|\\[|\\]|\\{|\\}|,|;|\\?|-|\\!|\"|\'|\`|\\^|\/", " ", tolower(readChar(zz, 1000000)) )), " ")[[1]]
        close(zz)
        
        vec = vector( mode="numeric", length(termlist) )
        
        for ( word in q ) {
            if (stemming) word = wordStem(word, language=language)
            if (word != "") {
                vec[ match(word,termlist) ] = vec[ match(word,termlist) ] + 1
            }
        }
        
        # vec now contains the original termlist
        dtm[(length(dtm)+1):(length(dtm)+wc)] = vec
        
    } # // for
    
    # now, make it a matrix
    dim(dtm) = c(wc,length(dtm)/wc)
    
    colnames(dtm) = doclist
    rownames(dtm) = termlist
    
    environment(dtm) = new.env()
    class(dtm) = "dtmatrix"
    
    return ( dtm )
    
}

query <- function( qtext, termlist, stemming=FALSE, language="german" ) {
    
    # qtext: string with the query words, whitespace separated
    # termlist: list of allowed terms
    # dtm: original doc-term-matrix (no weighting applied!)
    
    dtm = NULL
    
    q = strsplit( gsub('[[:space:][:punct:]]*', ' ', tolower(qtext) ), " ")[[1]]
    vec = vector( mode="numeric", length(termlist) )
    for ( word in q ) {
        if (stemming) word = wordStem(word, language=language)
        if (word != "") {
            vec[ match(word,termlist) ] = vec[ match(word,termlist) ] + 1
        }
    }
    
    dtm = as.matrix(vec)
    colnames(dtm) = toupper(qtext)
    rownames(dtm) = termlist
    
    environment(dtm) = new.env()
    class(dtm) = "dtmatrix"
    
    return ( dtm )
    
}

pseudo_svd <- function( docvecs, tk, sk ) {
    
    ### dqs = t(docvecs) %*% tk %*% solve(diag(sk))
    dqs = crossprod( t( crossprod(docvecs,tk) ), solve(diag(sk)) )
    ### alternative: dqs = crossprod( docvecs, crossprod(t(tk), solve(diag(sk))) )
    
    ### dtm = tk %*% diag(sk) %*% t(dqs)
    dtm = crossprod( t( crossprod(t(tk),diag(sk)) ), t(dqs) )
    
    dimnames(dtm) = dimnames(docvecs)
    
    environment(dtm) = new.env()
    class(dtm) = "dtmatrix"
    
    return (dtm)
    
}

