#!/bin/bash

find $SVN_ROOT/* -maxdepth 0 -type d | while IFS= read -r DIR
do
	NAME=`expr match "$DIR" '.*\(/.*\)'`
	
	if [ -f "$DIR/README.txt" ] && [ `cat "$DIR/README.txt" | grep "This is a Subversion repository" | wc -l` -eq 1 ]
	then
		echo "Already a SVN Filesystem  : $DIR"
	else
		echo "Creating a SVN Filesystem : $DIR"
		svnadmin create --fs-type fsfs "$DIR"
		chown -R www-data:www-data "$DIR"
	fi
done

chown -R www-data:www-data "$SVN_ROOT/"
