# -*- mode: shell-script -*-
#  Time-stamp: "2021-03-17 17:44:43 William P. McBee Jr."

# is $1 missing from $2 (or PATH) ?
    no_path() {
	eval "case :\$${2-PATH}: in *:$1:*) return 1;; *) return 0;; esac"
    }
    export -f no_path
# if $1 exists and is not in path, append it
    add_path () {
	[ -d ${1:-.} ] && no_path $* && eval ${2:-PATH}="\$${2:-PATH}:$1"
    }
    export -f add_path
# if $1 exists and is not in path, prepend it
    pre_path () {
	[ -d ${1:-.} ] && no_path $* && eval ${2:-PATH}="$1:\$${2:-PATH}"
    }
    export -f pre_path

# if $1 is in path, remove it
    del_path () {
	no_path $* || eval ${2:-PATH}=`eval echo :'$'${2:-PATH}: | sed -e "s;:$1:;:;g" -e "s;^:;;" -e "s;:\$;;"`
    }
    export -f del_path

    export OS=`uname`
    export ORGANIZATION="Interactic Holdings, LLC"
    export ANSIBLE_NOCOWS=1

    # exit here if not interactive
    [ -z "$PS1" ]  && return

    alias df='df -lPH'
    alias lf='ls -FC'
    alias ..='cd ..'
    alias ss='ps uax'
    alias clean='rm -i [%~#^,]* .*.{OLD,BAK,bak,backup} *.{OLD,BAK,bak,backup} *[%~#^,] .*[%~#^,] core*'
    alias rot13='tr a-zA-Z n-za-mN-ZA-M'
    function git-root {
	root=$(git rev-parse --git-dir 2> /dev/null)
	[[ -z "$root" ]] && root="."
	dirname $root
    }

    case $OS in
	Darwin)
	    export OS_VERSION=`sw_vers -productVersion`
	    export JAVA_HOME="$(/usr/libexec/java_home)"

	    ( which -s brew ) && export BREW_PREFIX=`brew --prefix`
	    ( which -s port ) && export PORTS_PREFIX=/opt/local
	    [ -n "$PORTS_PREFIX" ] && [ -n "$BREW_PREFIX" ] && echo "HomeBrew and MacPorts should NOT be installed together"
	    if [ -n "$BREW_PREFIX" ]; then
		export LOCAL_PREFIX=$BREW_PREFIX
	    else
		export LOCAL_PREFIX=$PORTS_PREFIX
	    fi
	    if [ -z "$SSH_CLIENT" ]; then
		alias em='open -b org.gnu.emacs'
	    elif [ -n "$LOCAL_PREFIX" ]; then
		alias emacs=$LOCAL_PREFIX/bin/emacs
		alias emacsclient=$LOCAL_PREFIX/bin/emacsclient
	    fi
	    if [ -z "$TERM_PROGRAM" ] && [ -z "$INSIDE_EMACS" ]; then
		export PS1='\[\e]0;\u@\h: \w\a\]\u@\h:\w\$ '
	    else
		PS1='\[\e]0;\h\a\]\h:\W \u\$ '
	    fi
	    if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$PROMPT_COMMAND" ]; then
		# "System-wide" bashrc should have already run.
		. /etc/bashrc
	    fi
	    if [ -f $LOCAL_PREFIX/etc/bash_completion ]; then
		. $LOCAL_PREFIX/etc/bash_completion
	    fi
	    # Add X11 libs to pkg-config path
	    [ -z "$PKG_CONFIG_PATH" ] && export PKG_CONFIG_PATH=`pkg-config --variable pc_path pkg-config`
	    add_path /opt/X11/lib/pkgconfig PKG_CONFIG_PATH
	    # Open a manpage in Preview, which can be saved to PDF
	    function pman {
		man -t "${1}" | open -f -a /System/Applications/Preview.app
	    }
	    # Open a manpage in the browser
	    function bman {
		man "${1}" | man2html | browser
	    }
	    alias workaround='sudo killall -KILL appleeventsd'
	    if [ -d ~/perl5 ]; then
		pre_path ~/perl5/bin
		pre_path ~/perl5/lib/perl5 PERL5LIB
		pre_path ~/perl5 PERL_LOCAL_LIB_ROOT
		export PERL5LIB PERL_LOCAL_LIB_ROOT
		PERL_MB_OPT="--install_base \"~/perl5\""; export PERL_MB_OPT;
		PERL_MM_OPT="INSTALL_BASE=~/perl5"; export PERL_MM_OPT;
		if [ -r ~/perl5/perlbrew/etc/bashrc ]; then
		    source ~/perl5/perlbrew/etc/bashrc
		fi
	    fi
	    export OMPI_CPPFLAGS="-I/usr/local/include"
	    export OMPI_LDFLAGS="-L/usr/local/lib"
	    export CPPFLAGS="-I/usr/local/include"
	    export LDFLAGS="-L/usr/local/lib"
	    eval "$(thefuck --alias)"
	    ;;
	Linux)
	    export PS1='\[\e]0;\u@\h: \w\a\]\u@\h:\w\$ '
	    if [ -f /etc/bashrc ]; then
		. /etc/bashrc
	    fi
	    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
		. /etc/bash_completion
	    fi
	    alias rm='rm -I'
	    alias open=xdg-open
	    ;;
	SunOS)
	    export PS1='\[\e]0;\u@\h: \w\a\]\u@\h:\w\$ '
	    ;;
	Windows*)
	    # Native port of bash (really sucks!)
	    export PS1='\u@\h:\w\$ '
	    ;;
	CYGWIN*)
	    if [ -n "$SSH_CLIENT" ]; then
		PS1='\[\e]0;\u@\h: \w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
	    fi
	    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
		. /etc/bash_completion
	    fi
	    alias rm='rm -I'
	    alias lf='ls -hF --color=tty'                 # classify files in colour
	    alias open=cygstart
	    ;;
	Interix*)
	    echo "I have Windows 7 Ultimate???"
	    ;;
    esac


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
