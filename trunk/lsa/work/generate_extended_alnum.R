
# generate regular expression for gsub replacement
# of all but alpha numeric characters: including
# special characters in Polish and German

setwd("~/Documents/werkstatt/lsa-package/lsa/work/")

alnumx = "[^[:alnum:]\\_ĄąĘęÓóĆćŁłŃńŚśŹźŻżÄäÖöÜüß]"
save(alnumx, file="../data/alnumx.rda", ascii=T)

