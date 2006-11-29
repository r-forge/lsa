### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### corpus_sample.R
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### created 2006-07-31


corpus_sample <- function (filelist, samplesize, index.return=FALSE) {

	rnd_sample = sample(1:length(filelist), samplesize)
	if (index.return) {
		return(list(x=filelist[rnd_sample],ix=rnd_sample))
	} else {
		return(filelist[rnd_sample])
	}
	
}
