#!/bin/bash

cat index | while read line
do
	words=($line) ## interpret the whitespace separated line as an array of words
	cp -r ${words[1]} ${words[0]}
done

# recursively remove .git repos
# EXCEPT for the .git directory in the root directory
# the parenthesis around the cd command cause it to run in a subshell
for dir in ./*/
do
	(cd "$dir" && find . -name ".git" -type d -exec rm -rf {} \;)
done
