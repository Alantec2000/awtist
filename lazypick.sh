#!/bin/bash

# Parametrização #
while [ "$1" != "" ]; do
    case $1 in
        -b | --branch )         shift
                                branch=$1
                                ;;
        "-g" | "--grep" )       shift
                                grep="--grep=$1"
                                ;;
        "-a" | "--author" )       shift
                                author="--author=$1"
                                ;;
	"-c" | "--copy" )	shift
				copy="xsel -b"
				;;
	"-n" | "--number")	shift
				number="-n $1"
				;;
    esac
    shift
done

# Main #

git cherry-pick --abort

if [ -z $number ]; then
    number="";
fi

if [ -z $branch ]; then
    echo "Informe um branch para procurar seus commits: ";
    read branch;
    if [ -z $branch ]; then
        branch=$(git branch | grep "*" | cut -b2-);
        echo "Buscando commits do branch atual $branch";
    fi
fi

if [ -z $grep ]; then
    echo "Buscando qualquer commit do branch atual($(whoami))";
fi

if [ -z $author ]; then
    author="--author=$(whoami)";
    echo "Nenhum usuário informado buscando commits de $(whoami);";
fi

result=$(git log $branch $author $number --no-merges --reverse --oneline $grep --pretty=format:"%h")

echo $result

if [ -z $copy ]; then
	git cherry-pick $result;
else
        echo $result | xsel -b;
fi


