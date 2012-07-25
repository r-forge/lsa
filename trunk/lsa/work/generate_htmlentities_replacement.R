
# generate regular expression for gsub replacement
# of all but alpha numeric characters: including
# special characters in Polish and German

setwd("~/Documents/werkstatt/lsa-package/lsa/work/")

entities = NULL
replacement = NULL

entities = append(entities, "&auml;")
replacement = append(replacement, "ä")

entities = append(entities, "&uuml;")
replacement = append(replacement, "ü")

entities = append(entities, "&ouml;")
replacement = append(replacement, "ö")

entities = append(entities, "&szlig;")
replacement = append(replacement, "ß")

entities = append(entities, "&#260;")
replacement = append(replacement, "ą")

entities = append(entities, "&#261;")
replacement = append(replacement, "ą")

entities = append(entities, "&#280;")
replacement = append(replacement, "ę")

entities = append(entities, "&#281;")
replacement = append(replacement, "ę")

entities = append(entities, "&#211;")
replacement = append(replacement, "ó")

entities = append(entities, "&oacute;")
replacement = append(replacement, "ó")

entities = append(entities, "&#243;")
replacement = append(replacement, "ó")

entities = append(entities, "&#262;")
replacement = append(replacement, "ć")

entities = append(entities, "&#263;")
replacement = append(replacement, "ć")

entities = append(entities, "&#321;")
replacement = append(replacement, "ł")

entities = append(entities, "&#322;")
replacement = append(replacement, "ł")

entities = append(entities, "&#323;")
replacement = append(replacement, "ń")

entities = append(entities, "&#324;")
replacement = append(replacement, "ń")

entities = append(entities, "&#346;")
replacement = append(replacement, "ś")

entities = append(entities, "&#347;")
replacement = append(replacement, "ś")

entities = append(entities, "&#377;")
replacement = append(replacement, "ź")

entities = append(entities, "&#378;")
replacement = append(replacement, "ź")

entities = append(entities, "&#379;")
replacement = append(replacement, "ż")

entities = append(entities, "&#380;")
replacement = append(replacement, "ż")

specialchars = list(entities=entities, replacement=replacement)

save(specialchars, file="../data/specialchars.rda", ascii=T)

