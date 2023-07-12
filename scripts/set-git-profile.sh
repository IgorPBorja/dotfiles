#!/bin/bash
# usage: "set-git-profile profile"
# flags :
# 1. -g (global changes)

use_global=false

while getopts ":g" arg; do
    case "${arg}" in
        g)
            use_global=true
            echo "Making global changes."
            ;;
        :)
            ;;
        ?)
            echo "Invalid command flag -${OPTARG}. Ignoring."
            ;;
    esac
done
# remove the flagged arguments from the positional variables
# https://unix.stackexchange.com/questions/716777/how-to-mix-plain-arguments-with-flagged-arguments-in-bash-scripting
shift $((OPTIND - 1))

if [ "${use_global}" = true ]; then
    if [ "$1" =  "IgorPBorja" ]; then
        echo "Switching (globally) to github profile IgorPBorja"
	echo "e-mail igorpradoborja@gmail.com"
        git config --global user.name IgorPBorja
        git config --global user.email igorpradoborja@gmail.com
        git config --global credential.username IgorPBorja
        echo "Changing credentials..."
        cp ~/.ssh/id_rsa_personal ~/.ssh/id_rsa
        cp ~/.ssh/id_rsa_personal.pub ~/.ssh/id_rsa.pub
        echo "Process complete!"
        git config --list
    elif [ "$1" =  "Igor-Prado-Borja" ]; then
        echo "Switching (globally) to github profile Igor-Prado-Borja"
	echo "e-mail igorborja@ufba.br"
        git config --global user.name Igor-Prado-Borja
        git config --global user.email igorborja@ufba.br
        git config --global credential.username Igor-Prado-Borja
        echo "Changing credentials..."
        cp ~/.ssh/id_rsa_ufba ~/.ssh/id_rsa
        cp ~/.ssh/id_rsa_ufba.pub ~/.ssh/id_rsa.pub
        echo "Process complete!"
        git config --list
    else
        echo "Invalid username '$1'. No credentials altered"
    fi
elif [ $(git rev-parse --quiet --git-dir) ]; then
    # https://stackoverflow.com/questions/23507400/test-if-current-repo-is-under-git-in-bash
    if [ "$1" =  "IgorPBorja" ]; then
        echo "Switching (locally) to github profile IgorPBorja"
	echo "e-mail igorpradoborja@gmail.com"
        git config ${use_global} user.name IgorPBorja
        git config ${use_global} user.email igorpradoborja@gmail.com
        git config ${use_global} credential.username IgorPBorja
        echo "Changing credentials..."
        cp ~/.ssh/id_rsa_personal ~/.ssh/id_rsa
        cp ~/.ssh/id_rsa_personal.pub ~/.ssh/id_rsa.pub
        echo "Process complete!"
        git config --list
    elif [ "$1" =  "Igor-Prado-Borja" ]; then
        echo "Switching (locally) to github profile Igor-Prado-Borja"
	echo "e-mail igorborja@ufba.br"
        git config ${use_global} user.name Igor-Prado-Borja
        git config ${use_global} user.email igorborja@ufba.br
        git config ${use_global} credential.username Igor-Prado-Borja
        echo "Changing credentials..."
        cp ~/.ssh/id_rsa_ufba ~/.ssh/id_rsa
        cp ~/.ssh/id_rsa_ufba.pub ~/.ssh/id_rsa.pub
        echo "Process complete!"
        git config --list
    else
        echo "Invalid username '$1'. No credentials altered"
    fi
fi
