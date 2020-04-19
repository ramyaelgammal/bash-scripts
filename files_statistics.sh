#!/bin/bash
    
# ./file.sh [-l location] [--location location] [-e extension]
#           [--extension extension] [-h help] [--help help]
LOC_SET=0
STATS=0
function usage() {
  echo "USAGE: $0 ..."
exit 1
}

while [ $# -gt 0 ]
do
  case $1 in
    -l|--location )
        LOC="$2"
        if ! [ -d "$LOC" ]; then
          usage
        fi
        LOC_SET=1
        shift
        shift
        ;;
    -e|--extension )
        EXT="$2"
        shift 2
        ;;
    -s|--stats )
        STATS=1
        shift
        ;;
    -h|--help )
        usage
        shift
        ;;
    * )
        usage
        ;;
  esac
done
 
if [ $LOC_SET -ne 1 ]; then
  LOC=$(pwd)
fi

echo "Location is: $LOC"

if [ "$EXT" != "" ]; then

  ls -l $LOC | grep '^-'| grep "\.$EXT$" &> /dev/null
  if [ $? -ne 0 ]; then
    echo "No file with extension: $EXT found"
    exit 2
  else 
    echo "FILEs with .$EXT exist".
  fi
  ls -l $LOC | awk '/^-/' | grep "\.$EXT$" | awk -v stats=$STATS  -v ext=$EXT -f size.awk
fi
ls -l $LOC | grep "^-" | awk -v stats=$STATS -f size.awk
