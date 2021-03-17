export OS=`uname`
export ORGANIZATION="Interactic Holdings, LLC"
export ANSIBLE_NOCOWS=1

# exit here if not interactive
[ -z "$PS1" ]  && return

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/William McBee/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt correct

alias df='df -lPH'
alias lf='ls -FC'
alias ..='cd ..'
alias ss='ps uax'
alias clean='rm -i [%~#^,]* .*.{OLD,BAK,bak,backup} *.{OLD,BAK,bak,backup} *[%~#^,] .*[%~#^,] core*'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias lsuid="print -l \${^path}/*(Ns,S)"

# zsh-lovers global aliases
alias -g C='| wc -l'
alias -g D="DISPLAY=:0.0"
alias -g DN=/dev/null
alias -g ED="export DISPLAY=:0.0"
alias -g EG='|& egrep'
alias -g EH='|& head'
alias -g EL='|& less'
alias -g ELS='|& less -S'
alias -g ETL='|& tail -20'
alias -g ET='|& tail'
alias -g F=' | fmt -'
alias -g G='| egrep'
alias -g H='| head'
alias -g HL='|& head -20'
alias -g Sk="*~(*.bz2|*.gz|*.tgz|*.zip|*.z)"
alias -g LL="2>&1 | less"
alias -g L="| less"
alias -g LS='| less -S'
alias -g M='| more'
alias -g NE="2> /dev/null"
alias -g NS='| sort -n'
alias -g NUL="> /dev/null 2>&1"
alias -g RNS='| sort -nr'
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g US='| sort -u'
alias -g X0G='| xargs -0 egrep'
alias -g X0='| xargs -0'
alias -g XG='| xargs egrep'
alias -g X='| xargs'

# zsh-lovers zstyle lines
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' \
       max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*:functions' ignored-patterns '_*'
xdvi() { command xdvi ${*:-*.dvi(om[1])} }
zstyle ':completion:*:*:xdvi:*' menu yes select
zstyle ':completion:*:*:xdvi:*' file-sort time
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:cd:*' ignore-parents parent pwd

rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

autoload -Uz promptinit
promptinit
prompt clint

case $OS in
    Darwin)
	export OS_VERSION=`sw_vers -productVersion`
	export JAVA_HOME="$(/usr/libexec/java_home)"

	alias -g VM=/var/log/system.log
	( whence brew >& /dev/null ) && export BREW_PREFIX=`brew --prefix`
	( whence port >& /dev/null ) && export PORTS_PREFIX=/opt/local
	[ -n "$PORTS_PREFIX" ] && [ -n "$BREW_PREFIX" ] && echo "HomeBrew and MacPorts should NOT be installed together"
	if [ -n "$BREW_PREFIX" ]; then
	    export LOCAL_PREFIX=$BREW_PREFIX
	else
	    export LOCAL_PREFIX=$PORTS_PREFIX
	fi
	if [ -z "$SSH_CLIENT" ]; then
	    alias em='open -b org.gnu.emacs'
	    alias -s txt=emacs
	    alias -s c=emacs
	    alias -s h=emacs
	elif [ -n "$LOCAL_PREFIX" ]; then
	    alias emacs=$LOCAL_PREFIX/bin/emacs
	    alias emacsclient=$LOCAL_PREFIX/bin/emacsclient
	fi

	# Add X11 libs to pkg-config path
	[ -z "$PKG_CONFIG_PATH" ] && export PKG_CONFIG_PATH=`pkg-config --variable pc_path pkg-config`
	PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/X11/lib/pkgconfig"
	# Open a manpage in Preview, which can be saved to PDF
	function pman {
	    man -t "${1}" | open -f -a /System/Applications/Preview.app
	}
	# Open a manpage in the browser
	function bman {
	    man "${1}" | man2html | browser
	}
	alias workaround='sudo killall -KILL appleeventsd'
	export OMPI_CPPFLAGS="-I/usr/local/include"
	export OMPI_LDFLAGS="-L/usr/local/lib"
	export CPPFLAGS="-I/usr/local/include"
	export LDFLAGS="-L/usr/local/lib"
	eval "$(thefuck --alias)"
	;;
    Linux)
	if [ -f /etc/zshrc ]; then
	    . /etc/zshrc
	fi
	alias -g VM=/var/log/messages
	alias rm='rm -I'
	alias open=xdg-open
	;;
    SunOS)
	;;
    CYGWIN*)
	alias rm='rm -I'
	alias lf='ls -hF --color=tty'                 # classify files in colour
	alias open=cygstart
	;;
esac


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
