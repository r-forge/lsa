textmatrix <- function( mydir, stemming=FALSE, language="english", minWordLength=2, maxWordLength=FALSE, minDocFreq=1, maxDocFreq=FALSE, minGlobFreq=FALSE, maxGlobFreq=FALSE, stopwords=NULL, vocabulary=NULL, phrases=NULL, removeXML=FALSE, removeNumbers=FALSE) {

	myfiles = NULL
	if ( length(mydir) > 1 ) {

		# mydir must be a directory (or a list of directories) - not a file name
		for (i in 1:length(mydir)) {
			if (file.info(normalizePath(mydir[i]))$isdir==TRUE) {
				if (is.null(myfiles) == TRUE) {
					myfiles = Corpus(DirSource(mydir[i]), readerControl = list(reader = readPlain, language = language))
				} else {
					myfiles = append(myfiles, Corpus(DirSource(mydir[i]), readerControl = list(reader = readPlain, language = language)))
				}
			} else {
				warning( paste("[textmatrix] - WARNING: dir ",mydir[i], " does not exist.", sep=""))
			}

		}

	} else if (file.info(normalizePath(mydir))$isdir==TRUE) {
		myfiles = Corpus(DirSource(mydir), readerControl = list(reader = readPlain, language = language))
	} else {
		stop("[textmatrix] - ERROR: specified input directory does not exist.")
	}

	# do text transormations
	dummy = textvector( myfiles, stemming, language, minWordLength, maxWordLength, minDocFreq, maxDocFreq, stopwords, vocabulary, phrases, removeXML, removeNumbers)

	# if (!is.null(vocabulary)) {
	# ...        

	# term-documet-matrix
	tdm <- TermDocMatrix(dummy)

	# conversion into document-term-matrix
	dtm = t(as.matrix(tdm));

	environment(dtm) = new.env()
	class(dtm) = "textmatrix"

	return ( dtm )
    
}












textvector <- function (file, stemming=FALSE, language="english", minWordLength=2, maxWordLength=FALSE, minDocFreq=1, maxDocFreq=FALSE, stopwords=NULL, vocabulary=NULL, phrases=NULL, removeXML=FALSE, removeNumbers=FALSE ) {

	txt = file

	# as plain text
	# german umlaute?
	if (removeXML) {
		txt = tmMap(txt, asPlain)
	}

		
	# language = "arabic"?
	# phrases

	# stopword filtering
	if (!is.null(stopwords)) {
		txt = tmMap(txt, removeWords, stopwords(stopwords))
	}

	# stemming
	if (stemming) {
		txt = tmMap(txt, stemDoc)
	}
	
	# vocabulary filtering?

	# bandwith for document frequency?
    
	# word-length filtering?
    
	# remove numbers
	if (removeNumbers) {
		txt = tmMap(txt, removeNumbers)
	}
	
	# error message if textcollection is empty
	#if (length(names(tab))==0) warning(paste("[textvector] - the file ", file, " contains no terms after filtering.", sep=""))
	
	return ( txt )

}




