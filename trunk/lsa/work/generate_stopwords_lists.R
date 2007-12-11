
setwd("c:/werkstatt/lsa-package/lsa/work/")

stopwords_de = tolower( scan("stopwords_german.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )
stopwords_en = tolower( scan("stopwords_english.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )

### Thanks to Marco Kalz, Open University Netherlands!
stopwords_nl = tolower( scan("stopwords_dutch.txt", what="character", sep = " ", quiet = TRUE, encoding = "UTF-8") )

save(stopwords_de, file="../data/stopwords_de.rda")
save(stopwords_en, file="../data/stopwords_en.rda")
save(stopwords_nl, file="../data/stopwords_nl.rda")