#!/bin/bash

function logStart {
   echo "[`date "+%Y-%m-%d %H:%M:%S"`] START: === $1 ==="
}

function logEnd {
   echo "[`date "+%Y-%m-%d %H:%M:%S"`]   END: === $1 ==="
}

function logInfo {
   echo "[`date "+%Y-%m-%d %H:%M:%S"`]  INFO: $1"
}

function logError {
   echo "[`date "+%Y-%m-%d %H:%M:%S"`] ERROR: $1"
}

function packageNameFromXML {
    echo `grep "<name>" package.xml | sed -e :a -e 's/<[^>]*>//g;/</N;//ba'`
}

# Get the dir and save current
DIR=$( cd "$( dirname "$0" )" && pwd )
CURDIR=`pwd`
logInfo "Changing to $DIR"
cd $DIR

## Clean up
logStart "Prebuild clean"
rm -Rf Log
rm -Rf Build
mkdir Log
mkdir -p Build/Packages
logEnd "Prebuild clean"

## Build logger

logStart "Building dependent packages"
src="Libraries"
#enable for loops over items with spaces in their name
IFS=$'\n'
 
for dir in `ls "$src/"`
do
  if [ -d "$src/$dir" ]; then
      cd $src/$dir
      if [ -e "package.xml" ]; then
	  logInfo "Building $(packageNameFromXML)"
	  gst-package -t $DIR/Build/Packages --test package.xml > $DIR/Log/BuildLog-$(packageNameFromXML).log
      fi
      cd $DIR
  fi
done

logEnd "Building dependent packages"

## Done 
logInfo "Changing back to orginating dir $CURDIR"
cd $CURDIR
