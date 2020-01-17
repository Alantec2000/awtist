#!/bin/bash


if [ -f ~/erros_merge ]; then
    rm ~/erros_merge;
fi

touch ~/erros_merge

for projeto in ${@:1}
do
    cd /var/www/$projeto;

    rebase_qa2=false;
    rebase_develop=false;
    no_branch="";

    echo "Rebase do projeto $projeto no caminho $(pwd)";

    #Atualização do develop
    git rebase --abort >/dev/null 2>&1;
    git checkout develop >/dev/null 2>&1;
    git pull origin develop >/dev/null 2>&1;
    git reset --hard origin/develop >/dev/null 2>&1;

    #rebase do branch de qa2
    git checkout qa2 >/dev/null 2>&1 ;
    git fetch >/dev/null 2>&1 ;
    git reset --hard origin/qa2 >/dev/null 2>&1;
    git pull origin qa2 >/dev/null 2>&1;
    git reset --hard origin/qa2 >/dev/null 2>&1;
    git rebase develop >/dev/null 2>&1;

    status=$(git status | grep "corrija os conflitos")

    if [ -z "$status" ]; then
	    git push origin qa2 --force-with-lease >/dev/null 2>&1;

	    #rebase da branch de develop
	    git checkout develop >/dev/null 2>&1 ;
	    git fetch >/dev/null 2>&1 ;
	    git reset --hard origin/develop >/dev/null 2>&1;
	    git pull origin develop >/dev/null 2>&1;
	    git reset --hard origin/develop >/dev/null 2>&1;
	    git rebase qa2 >/dev/null 2>&1;

	    status=$(git status | grep "corrija os conflitos")

	    if [ -n "$status" ]; then
        	echo "$projeto no rebase do develop para o qa2" >> ~/erros_merge;
	    fi
    else
	echo "$projeto no rebase do qa2 para develop" >> ~/erros_merge;
    fi
done

echo
echo "Projetos com erro de MERGE a serem corrigidos"
cat ~/erros_merge
rm ~/erros_merge
