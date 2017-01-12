#!/bin/bash

find $SVN_ROOT/* -maxdepth 0 -type d | while IFS= read -r DIR
do
	NAME=`expr match "$DIR" '.*\(/.*\)'`
	echo "svnadmin dump $DIR > $SVN_BACKUP$NAME.dump"
	svnadmin dump $DIR > $SVN_BACKUP$NAME.dump
done
