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
        dtm = t(xtabs(Freq ~ ., data = do.call("rbind", dummy)))
        result = matrix(0, nrow=length(vocabulary), ncol=ncol(dtm))
        rownames(result) = vocabulary
        result[rownames(dtm),] = dtm[rownames(dtm),]
        colnames(result) = colnames(dtm)
        dtm = result
        gc()
    } else {
        dtm = t(xtabs(Freq ~ ., data = do.call("rbind", dummy)))
    }
    
    environment(dtm) = new.env()
    class(dtm) = "textmatrix"
    
    return ( dtm )
    
}

print.textmatrix <- function ( x, bag_lines = 12, bag_cols = 10, ... ) {
    
    nc = ncol(x);
    nr = nrow(x);    
    
    if (nc <= (3*bag_cols) && nr <= (3*bag_lines)) {
        print.matrix(x);
    } else {
        
        redx = matrix(ncol = (3*bag_cols), nrow = (3*bag_lines));
        mid = round(nrow(x)/2)
        midc = round(ncol(x)/2)
        
        # top
        redx[1:bag_lines, 1:bag_cols] = x[1:bag_lines, 1:bag_cols]
        redx[1:bag_lines, (bag_cols+1):(bag_cols+bag_cols)] = x[1:bag_lines, midc:(midc+bag_cols-1)]
        redx[1:bag_lines, (2*bag_cols+1):(3*bag_cols)] = x[1:bag_lines, (ncol(x)-bag_cols+1):ncol(x)]
        
        # mid
        redx[(bag_lines+1):(bag_lines*2), 1:bag_cols] = x[mid:(mid+bag_lines-1), 1:bag_cols]
        redx[(bag_lines+1):(bag_lines*2), (bag_cols+1):(bag_cols+bag_cols)] = x[mid:(mid+bag_lines-1), midc:(midc+bag_cols-1)]
        redx[(bag_lines+1):(bag_lines*2), (2*bag_cols+1):(3*bag_cols)] = x[mid:(mid+bag_lines-1), (ncol(x)-bag_cols+1):ncol(x)]
        
        # bottom
        redx[(bag_lines*2+1):(bag_lines*3), 1:bag_cols] = x[(nrow(x)-bag_lines+1):nrow(x), 1:bag_cols]
        redx[(bag_lines*2+1):(bag_lines*3), (bag_cols+1):(bag_cols+bag_cols)] = x[(nrow(x)-bag_lines+1):nrow(x), midc:(midc+bag_cols-1)]
        redx[(bag_lines*2+1):(bag_lines*3), (2*bag_cols+1):(3*bag_cols)] = x[(nrow(x)-bag_lines+1):nrow(x), (ncol(x)-bag_cols+1):ncol(x)]
                
        # dixnaxes
        rownames(redx) = c( paste(1:bag_lines,rownames(x)[1:bag_lines],sep=". "), paste(mid:(mid+bag_lines-1),rownames(x)[(mid):(mid+bag_lines-1)],sep=". "), paste((nrow(x)-bag_lines+1):nrow(x), rownames(x)[(nrow(x)-bag_lines+1):nrow(x)], sep=". "))
        colnames(redx) = paste("D", c( 1:bag_cols, midc:(midc+bag_cols-1), (ncol(x)-bag_cols+1):ncol(x) ), sep="")
        docnames = paste( colnames(redx), c( colnames(x)[1:bag_cols], colnames(x)[midc:(midc+bag_cols-1)], colnames(x)[(ncol(x)-bag_cols+1):ncol(x)] ), sep=" = ")
        
        ret = NULL
        ret$matrix = redx;
        ret$legend = docnames;
        
        print(ret);
        invisible(x);
        
    }
    
}

summary.textmatrix <- function ( object, ... ) {
    
    s = matrix(ncol=1, nrow=5);
    n = vector(mode="character", length=5);
    n[1] = "vocabulary";
    s[1] = length(rownames(object));
    n[2] = "documents";
    s[2] = length(colnames(object));
    n[3] = "freqs not '0'";
    s[3] = length(which(object>0));
    n[4] = "max term length";
    s[4] = max(nchar(rownames(object),type="chars"));
    n[5] = "non-alphanumerics in terms";
    s[5] = length(which(gsub("[[:alnum:]]|[ÄÖÜäöüß]", "", rownames(object)) != ""));
    rownames(s) = n;
    colnames(s)="value";
    class(s) = "summary.textmatrix";
    s
    
}

