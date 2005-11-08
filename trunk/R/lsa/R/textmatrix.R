### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### textmatrix
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### dependencies: library("RStem")
### 
### !!!!! WARNING: you currently cannot use textmatrix with vocabulary=s.th. !!!!!
### 2005-11-08: added print and summary functions
### 2005-11-08: added vocabulary filter to both functions
### 2005-10-04: added nchar(..., type="chars") to count characters, not bytes
### 2005-08-25: added "\\[|\\]|\\{|\\}" to gsub
### 2005-08-26: renamed dt_triples to textvector and dt_matrix to textmatrix

textvector <- function (file, stemming=FALSE, language="german", minWordLength=3, minDocFreq=1, stopwords=NULL, vocabulary=NULL) {
    
    txt = scan(file, what = "character", quiet = TRUE)
    txt = gsub( "\\.|:|\\(|\\)|\\[|\\]|\\{|\\}|,|;|\\?|-|\\!|\"|\'|\`|\\^|\=|\’|\–|\„|\”|\/", " ", txt)
    txt = gsub("[[:space:]]+", " ", txt)
    txt = tolower(txt)
    txt = unlist(strsplit(txt, " ", fixed=TRUE))
    
    # stopword filtering?
    if (!is.null(stopwords)) txt = txt[!txt %in% stopwords]
    
    # vocabulary filtering?
    if (!is.null(vocabulary)) txt = txt[txt %in% vocabulary]
    
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

textmatrix <- function( mydir, stemming=FALSE, language="german", minWordLength=3, minDocFreq=1, stopwords=NULL, vocabulary=NULL ) {
    
    dummy = lapply( dir(mydir, full.names=TRUE), textvector, stemming, language, minWordLength, minDocFreq, stopwords, vocabulary)
    if (!is.null(vocabulary)) {
        dtm = t(xtabs(Freq ~ ., data = do.call("rbind", dummy), col.vars=vocabulary))
    } else {
        dtm = t(xtabs(Freq ~ ., data = do.call("rbind", dummy)))
    }
    
    environment(dtm) = new.env()
    class(dtm) = "textmatrix"
    
    return ( dtm )
    
}

print.textmatrix <- function ( m, bag_lines = 12, bag_cols = 10 ) {
    
    nc = ncol(m);
    nr = nrow(m);    
    
    if (nc <= (3*bag_cols) && nr <= (3*bag_lines)) {
        print.matrix(m);
    } else {
        
        redm = matrix(ncol = (3*bag_cols), nrow = (3*bag_lines));
        mid = round(nrow(m)/2)
        midc = round(ncol(m)/2)
        
        # top
        redm[1:bag_lines, 1:bag_cols] = m[1:bag_lines, 1:bag_cols]
        redm[1:bag_lines, (bag_cols+1):(bag_cols+bag_cols)] = m[1:bag_lines, midc:(midc+bag_cols-1)]
        redm[1:bag_lines, (2*bag_cols+1):(3*bag_cols)] = m[1:bag_lines, (ncol(m)-bag_cols+1):ncol(m)]
        
        # mid
        redm[(bag_lines+1):(bag_lines*2), 1:bag_cols] = m[mid:(mid+bag_lines-1), 1:bag_cols]
        redm[(bag_lines+1):(bag_lines*2), (bag_cols+1):(bag_cols+bag_cols)] = m[mid:(mid+bag_lines-1), midc:(midc+bag_cols-1)]
        redm[(bag_lines+1):(bag_lines*2), (2*bag_cols+1):(3*bag_cols)] = m[mid:(mid+bag_lines-1), (ncol(m)-bag_cols+1):ncol(m)]
        
        # bottom
        redm[(bag_lines*2+1):(bag_lines*3), 1:bag_cols] = m[(nrow(m)-bag_lines+1):nrow(m), 1:bag_cols]
        redm[(bag_lines*2+1):(bag_lines*3), (bag_cols+1):(bag_cols+bag_cols)] = m[(nrow(m)-bag_lines+1):nrow(m), midc:(midc+bag_cols-1)]
        redm[(bag_lines*2+1):(bag_lines*3), (2*bag_cols+1):(3*bag_cols)] = m[(nrow(m)-bag_lines+1):nrow(m), (ncol(m)-bag_cols+1):ncol(m)]
                
        # dimnames
        rownames(redm) = c( paste(1:bag_lines,rownames(m)[1:bag_lines],sep=". "), paste(mid:(mid+bag_lines-1),rownames(m)[(mid):(mid+bag_lines-1)],sep=". "), paste((nrow(m)-bag_lines+1):nrow(m), rownames(m)[(nrow(m)-bag_lines+1):nrow(m)], sep=". "))
        colnames(redm) = paste("D", c( 1:bag_cols, midc:(midc+bag_cols-1), (ncol(m)-bag_cols+1):ncol(m) ), sep="")
        docnames = paste( colnames(redm), c( colnames(m)[1:bag_cols], colnames(m)[midc:(midc+bag_cols-1)], colnames(m)[(ncol(m)-bag_cols+1):ncol(m)] ), sep=" = ")
        
        ret = NULL
        ret$matrix = redm;
        ret$legend = docnames;

        return( ret )
        
    }
    
}

summary.textmatrix <- function ( m ) {
    
    s = matrix(ncol=1, nrow=5);
    n = vector(mode="character", length=5);
    n[1] = "vocabulary";
    s[1] = length(rownames(m));
    n[2] = "documents";
    s[2] = length(colnames(m));
    n[3] = "freqs not '0'";
    s[3] = length(which(m>0))
    n[4] = "max term length";
    s[4] = max(nchar(rownames(dtm),type="chars"))
    n[5] = "non-alphanumerics in terms";
    s[5] = length(which(gsub("[[:alnum:]]|[ÄÖÜäöüß]", "", rownames(m)) != ""))
    rownames(s) = n
    colnames(s)="value"
    s
    
}

