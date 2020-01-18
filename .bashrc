#You don't have to get all the data in the level. As mentioned previously, use the guide to get the data up to the required threshold and leave the level.
#force_color_prompt=yes
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

captura()
{
	captura=$1
	until [ -n "$captura" ]
	do
		echo "Informe uma captura para teste!";
                read captura;
	done

	capturaPath="/var/www/captura/test/$captura.js";
	
	[ ! -e "$capturaPath" ] && echo "'$capturaPath' Não existe" || exit

	echo $capturaPath
}


isGitRepository() {
	isGitProject=$(git status >/dev/null 2>&1 | grep "fatal: Not a git repository")

        if [ -z "$isGitProject" ]; then
		return 0;
        else
		return 1;
	fi

}

gbname() {
	echo $(git branch | grep '*' | cut -c3-);
}

gush() {
	if isGitRepository; then
		branch=$(gbname);
		
		git push origin $branch;
		push=$(git status | grep 'use "git pull" ');
		if [ ! -z "$push" ]; then
			echo "tentando forçar..."
			push=$(git push origin $branch --force-with-lease);
		fi
		git log -n1 --pretty=format:"%h" | xsel -b
	fi
}

gull() {
        if isGitRepository; then
                branch=$(gbname);
		if [ -z "$1" ]; then
			branch=$1;
		fi
                git pull origin $branch --rebase;
        fi
}

gout() {
        if isGitRepository; then
                git checkout $1;
        fi
}

greset() {
        if isGitRepository; then
		alt=$(git status -s | wc -l);
		branch=$(gbname);
                if [ $alt -gt 0 ]; then
			git stash >/dev/null 2>&1;
                fi
		
		echo "resetando..."
		git reset --hard origin/$branch >/dev/null 2>&1;
		
		if [ $alt -gt 0 ]; then
                        git stash pop >/dev/null 2>&1;
                fi

		git status;
        fi
}

ghard() {
        if isGitRepository; then
                alt=$(git status -s | wc -l);
                echo "resetando..."
                git reset --hard origin/$(gbname);
                git status;
        fi

}

grommit() {
        if isGitRepository; then
                branch=$(gbname);
		alt=$(git status -s | wc -l)
		if [ $alt -gt 0 ]; then
			git add -i
			git commit;
			git stash
			gull;
			gush;
			git checkout ./;
			git stash pop;
			git log -n1 --pretty=format:"%h" | xsel -b
		else
			echo nada para commitar;	
		fi
        fi
}


gcnum() {
	if isGitRepository; then
		echo $(git log --oneline --author=$(whoami) | grep $1 | wc -l)
	fi
}

gopy() {
	if isGitRepository; then
		git log $1 -n1 --pretty=format:"%h" | xsel -b
        fi
}

alias gcp='git cherry-pick';
alias glog='git log';
alias gc='git commit';
alias gcm='git commit -m';
alias gst='git status';
alias gr='git rebase';
alias gadda='git add .';
alias gorce='git push origin $(gbname) --force-with-lease';
alias gb='git branch';
alias tinker='php artisan tinker';
alias gasha='gadda && git stash';
alias gashop='git stash apply stash@{0}';
alias phpTo7.3="sudo a2dismod php5.6 && sudo a2enmod php7.3 && sudo service apache2 restart && sudo update-alternatives --set php /usr/bin/php7.3"
alias phpTo5.6="sudo a2dismod php7.3 && sudo a2enmod php5.6 && sudo service apache2 restart && sudo update-alternatives --set php /usr/bin/php5.6"
zsh
