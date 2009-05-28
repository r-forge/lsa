
setwd("c:/werkstatt/lsa-package/lsa/work/")

stopwords_de = tolower( scan("stopwords_german.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )
stopwords_en = tolower( scan("stopwords_english.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )

### Thanks to Marco Kalz, Open University Netherlands!
stopwords_nl = tolower( scan("stopwords_dutch.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )

### thanks to Haykel Demnati (Haykel.Demnati@isg.rnu.tn)
### who combined and extended this from several other lists

stopwords_fr = tolower( scan("stopwords_french.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )
stopwords_fr = unlist(strsplit(stopwords_fr,"\n"))
stopwords_fr[1] = "$"

save(stopwords_de, file="../data/stopwords_de.rda", ascii=T)
save(stopwords_en, file="../data/stopwords_en.rda", ascii=T)
save(stopwords_nl, file="../data/stopwords_nl.rda", ascii=T)
save(stopwords_fr, file="../data/stopwords_fr.rda", ascii=T)