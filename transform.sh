#!/bin/bash

if [ $# -lt 2 ]
  then
    echo "Usage: transform.sh <INPUT_DIRECTORY> <OUTPUT_DIRECTORY>"
    exit 1
fi

INPUT_DIR=$1
OUTPUT_DIR=$2
CONF_DIR=$3
echo "INPUT: "$INPUT_DIR
echo "OUTPUT: "$OUTPUT_DIR

transform() {
  echo $(basename $1)
  FILE_NAME=$(basename "$1")
  FILE_NAME="$(echo "$FILE_NAME" | perl -pe 's/xml$/html/g')"
  CONF_DIR=$3
  OUTPUT_FILE=$2"/"$FILE_NAME
  echo $OUTPUT_FILE
  saxonb-xslt -strip:none -s:"$1" -xsl:"page.xsl" -o:"$OUTPUT_FILE" data_path="../nieuws_iswaar_data/" conf_path=$CONF_DIR
  return 0 
}

export -f transform

find $INPUT_DIR -name "*.xml" -type f -exec bash -c 'transform "$@"' bash {} $OUTPUT_DIR $INPUT_DIR \;
