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
	words=($line)
	if [ "$verbose" = true ]; then
		echo "Copying --${words[1]}-- from /home/${user} to ${words[0]}"
	fi
	rsync -lrv --exclude=.git "/home/${user}/${words[1]}" ${words[0]}
done
