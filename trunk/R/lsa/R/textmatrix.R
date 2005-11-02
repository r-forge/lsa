### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### textmatrix
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### dependencies: library("RStem")
### 
### 2005-10-04: added nchar(..., type="chars") to count characters, not bytes
### 2005-08-25: added "\\[|\\]|\\{|\\}" to gsub
### 2005-08-26: renamed dt_triples to textvector and dt_matrix to textmatrix
### 

textvector <- function (file, stemming=FALSE, language="german", minWordLength=3, minDocFreq=1, stopwords=NULL) {
    
    txt = scan(file, what = "character", quiet = TRUE)
    txt = gsub( "\\.|:|\\(|\\)|\\[|\\]|\\{|\\}|,|;|\\?|-|\\!|\"|\'|\`|\\^|\/", " ", txt)
    txt = gsub("[[:space:]]+", " ", txt)
    txt = tolower(txt)
    txt = unlist(strsplit(txt, " ", fixed=TRUE))
    
    # stopword filtering?
    if (!is.null(stopwords)) txt = txt[!txt %in% stopwords]
    
    # tabulate
    tab = sort(table(txt), decreasing = TRUE)
    
    # with threshold minDocFreq
    tab = tab[tab >= minDocFreq]
    
    # wordLength filtering?
    tab = tab[nchar(names(tab), type="chars") > minWordLength]
    
    # stemming?
    if (stemming) names(tab) = wordStem(names(tab), language=language)
    
    return( data.frame( docs=basename(file), terms = names(tab), Freq = tab, row.names = NULL) )
    
}

textmatrix <- function( mydir, stemming=FALSE, language="german", minWordLength=3, minDocFreq=1, stopwords=NULL ) {
    
    dummy = lapply( dir(mydir, full.names=TRUE), textvector, stemming, language, minWordLength, minDocFreq, stopwords)
    dtm = t(xtabs(Freq ~ ., data = do.call("rbind", dummy)))
    
    environment(dtm) = new.env()
    class(dtm) = "dtmatrix"
    
    return ( dtm )
    
}

