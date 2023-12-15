#!/bin/bash

## Receive verbosity (-v) flag
## If the flag is present, set the -v flag for the rest of the script

if [ "$1" == "--help" ]; then
	echo "Usage: ./include_script.sh [-v]"
	echo "	-v: verbose output"
	exit 0
fi

if [ "$1" == "-v" ]; then
	verbose=true
else
	verbose=false
fi

user=$(whoami)
cat index | while read line
do
	## words=($line) ## interpret the whitespace separated line as an array of words
	if [ "$verbose" = true ]; then
		echo "Copying --${line}--"
	fi
	cp -r "/home/$user/$line" "."
done

# recursively remove .git repos
# EXCEPT for the .git directory in the root directory
# the parenthesis around the cd command cause it to run in a subshell
if [ "$verbose" = true ]; then
	echo "Removing .git directories recursively"
fi
for dir in ./*/
do
	(cd "$dir" && find . -name ".git" -type d -exec rm -rf {} \;)
done
