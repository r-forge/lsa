
### ceeboo 2008

## NOTES 1) the readers cannot handle leading or trailing spaces
##       2) the dash in the outputfile is braindead (see below).

## write a dense matrix in sparse text format
write.D.ST <-
function(x, con = stdout(), sep = "\n") {
    if (!is.matrix(x))
        stop("'x' not a matrix")
    text <- paste(dim(x)[1], dim(x)[2], sum(x != 0))
    text <- c(text, apply(x, 2, function(x) {
        k <- which(x != 0)
        r <- as.character(length(k))
        if (length(k))
            r <- c(r, paste(k-1, x[k]))
        r
    }))
    writeLines(unlist(text, use.names = FALSE), con, sep)
}

## read a file in sparse text format into a dense matrix
read.ST.D <-
function(con = stdin(), encoding = "unknown") {
    ## get data
    text <- readLines(con, encoding = encoding)
    data <- lapply(strsplit(text, "[[:space:]]+"), as.numeric)
    ## set up matrix
    x <- matrix(0, nrow = data[[1]][1], ncol = data[[1]][2])
    data <- data[-1]
    ## get row / column indexes
    len <- sapply(data, length)
    col <- sapply(data[len == 1], eval)
    col <- rep(seq_len(length(col)), col)
    row <- as.integer(sapply(data[len == 2], "[", 1)) + 1L
    ## populate
    x[cbind(row, col)] <- sapply(data[len == 2], "[", 2)
    x
}

## read file in dense format
read.DT <-
function(con = stdin(), encoding = "unknown") {
    ## get data
    text <- readLines(con, encoding = encoding)
    data <- lapply(strsplit(text, "[[:space:]]+"), as.numeric)
    ## set up matrix
    matrix(sapply(data[-1], as.numeric), nrow = data[[1]][1], byrow = TRUE)
}

## test sparse read / write
x <- matrix(runif(12), nrow = 4)
x[sample(length(x), 4)] <- 0
print(x, digits = 2)

write.D.ST(x, con = "test.txt")

print(read.ST.D(con = "test.txt"), digits = 2)

## now check command line interfacing
## UNIX only, sorry.

system("./svd -d 2 -o ./ test.txt")

## not a matrix
as.numeric(readLines("-S")[-1])
read.DT("-Ut")
read.DT("-Vt")

## compare
system("cat -- -S -Ut -Vt")

## clean up the dash mess
system("rm -f -- -S -Ut -Vt")

system("rm -f test.txt")

###
