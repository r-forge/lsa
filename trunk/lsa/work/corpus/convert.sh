
# enter directory.

curdir="`pwd`"
curdir="`echo $curdir/$0`"

if [ -z "$1" ] ; then
   echo ">>> reading current dir."
else
   echo ">>> opening $1"
   cd $1/
fi

for myfile in *
do

  if [ "$myfile" != "*" ] ; then

     isdir=`file $myfile`
     # echo "### $isdir"

     if [ "`echo $isdir | grep -- ": directory"`" ] ; then
       echo ">>> $myfile is a directory" 
       $curdir $myfile
     else

       filetype=`file -i -b $myfile`
       echo ">>> $myfile is a file with char-set $filetype"

       case "$filetype" in
          "text/plain; charset=utf-8" )
             # iconv -f UTF-8 -t UTF-8 $file -o ../$2/$file
          ;;
          "text/plain; charset=iso-8859-1" ) 
             cp $myfile /tmp/tempfile
             iconv -f ISO-8859-1 -t UTF-8 -o $myfile /tmp/tempfile
             rm /tmp/tempfile 
             echo "converted from ISO-8859-1 to UTF-8"
          ;;
          "text/plain; charset=us-ascii" )
            cp $myfile /tmp/tempfile
            iconv -f ASCII -t UTF-8 -o $myfile /tmp/tempfile
            rm /tmp/tempfile
            echo "converted from ASCII to UTF-8"
          ;;
          * )
            cp $myfile /tmp/tempfile
            iconv -f ISO8859-1 -t UTF-8 -o $myfile /tmp/tempfile
            rm /tmp/tempfile
            echo "converted from unknown to UTF-8"
          ;;
       esac
       # echo "--------------------------------"

     fi # is directory

  fi # empty directory?

done

if [ -z "$1" ]
then
   echo "yip."
else
   cd ..
fi


