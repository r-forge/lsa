### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
### triples.r v0.1
### -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# convert input subject (column names or 
# column positions) to column position
# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
getSubjectId <- function(M, subject) {
    if (is.character(subject)) {
        return( which(match(colnames(M),subject)>0) );
    } else if (is.numeric(subject) && !any(subject>ncol(M)) ) {
        return( subject );
    } else return( NULL );
}

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# getTriple: return the value (=object) of the 
# requested triple(s) from the environment variables 
# "triples$S/P/O" the given matrix M. Leave out
# predicate to get all triples of the specified 
# subject. Leave out subject, to get all triples.
# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
getTriple <- function(M, subject, predicate) {
    
    if ( exists("triples$S",envir=environment(M)) ) {
        
        if ( ! missing(subject) ) {
        
            spos = which( get("triples$S",envir=environment(M)) == getSubjectId(M,subject));
            if ( ! missing(predicate)) {
                ppos = which( get("triples$P",envir=environment(M))[spos] == tolower(predicate) );
                objects = as.vector(get("triples$O",envir=environment(M))[spos][ppos]);
            } else {
                objects = list( as.vector(get("triples$P",envir=environment(M))[spos]), as.vector(get("triples$O",envir=environment(M))[spos]) );
            }
            
        } else {
            if ( length(get("triples$S",envir=environment(M))) == 0) {
                return( NULL );
            } else {
                return ( list( as.vector(get("triples$S",envir=environment(M))), as.vector(get("triples$P",envir=environment(M))), as.vector(get("triples$O",envir=environment(M))) ) );
            }
        }
        
        if ( length(objects)==0 ) {
            return( NULL );
        } else return( objects );

    } else return( NULL );

}

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# setTriple: enter a new triple into the environment 
# variables "triples$S/P/O" of the given matrix M.
# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
setTriple <- function(M, subject, predicate, object) {
    
    # create environment if not yet existing
    # BUG: does not survive this function !!!
    if ( ! is.environment(environment(M)) ) environment(M) = new.env();
    
    # if input is vectors, check if they 
    # have the same number of elements (else break)
    if (length(subject) != length(predicate) || length(predicate)!=length(object) || length(subject)!=length(object) ) return -1; 
    
    if ( ! exists("triples$S",envir=environment(M)) ) {
        
        # if not yet existing, add 'triples$S/P/O' to 
        # environment of M and insert first triple
        
        assign("triples$S", factor(getSubjectId(M,subject)), envir=environment(M) );
        assign("triples$P", factor(tolower(predicate)), envir=environment(M) );
        assign("triples$O", factor(object), envir=environment(M) );
        
        #assign("triples$S", vector(mode="numeric", length(subject)), envir=environment(M) );
        #assign("triples$S", getSubjectId(M, subject), envir=environment(M) );
        #assign("triples$P", vector(mode="character", length(predicate)), envir=environment(M) );
        #assign("triples$P", tolower(predicate), envir=environment(M) );
        #assign("triples$O", vector(mode="character", length(object)), envir=environment(M) );
        #assign("triples$O", object, envir=environment(M) );
        
        
    } else {
        
        if ( !any( is.na( match(getTriple(M, subject, predicate), object)) == FALSE)  ) {
            # triple does not exist, so append
            
            striples = get("triples$S",envir=environment(M));
            levels(striples) = unique(c(levels(striples), getSubjectId(M,subject)));
            striples[(length(striples)+1):(length(striples)+length(subject))] = getSubjectId(M,subject);
            assign("triples$S", striples, envir=environment(M));
            
            ptriples = get("triples$P",envir=environment(M));
            levels(ptriples) = unique(c(levels(ptriples), tolower(predicate)));
            ptriples[(length(ptriples)+1):(length(ptriples)+length(predicate))] = tolower(predicate);
            assign("triples$P", ptriples, envir=environment(M));
            
            otriples = get("triples$O",envir=environment(M));
            levels(otriples) = unique(c(levels(otriples), object));
            otriples[(length(otriples)+1):(length(otriples)+length(object))] = object;
            assign("triples$O", otriples, envir=environment(M));
            
            #assign("triples$S", c(get("triples$S",envir=environment(M)),getSubjectId(M,subject)), envir=environment(M) );
            #assign("triples$P", c(get("triples$P",envir=environment(M)),tolower(predicate)), envir=environment(M) );
            #assign("triples$O", c(get("triples$O",envir=environment(M)),object), envir=environment(M) );
        }
        
    } # insert triple(s)
    
} # // setTriple

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# retractTriple: remove specific triple(s) from
# environment of M. Currently not very memory sensitive ;)
# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
delTriple <- function(M, subject, predicate, object) {
    
    # find position
    spos = which( get("triples$S",envir=environment(M)) == getSubjectId(M,subject));
    ppos = which( get("triples$P",envir=environment(M))[spos] == tolower(predicate) );
    opos = which( get("triples$O",envir=environment(M))[spos][ppos] == object);
    origppos = ppos[opos];
    origspos = spos[origppos];
    
    # retract
    assign("triples$S", get("triples$S",envir=environment(M))[-origspos], envir=environment(M));
    assign("triples$P", get("triples$P",envir=environment(M))[-origspos], envir=environment(M));
    assign("triples$O", get("triples$O",envir=environment(M))[-origspos], envir=environment(M));
    
}

