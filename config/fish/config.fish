umask 002

if status --is-login

function on_exit --on-event fish_exit
    echo fish is now exiting
    sleep 1
    clear
    sleep 1
end

set -q LOCAL_BOOTSTRAP; or bootstrap
end

if status --is-interactive; and ! set -q INSIDE_EMACS

switch $OS
    case Darwin
	set -Ux OS_VERSION (sw_vers -productVersion)
	test -r /usr/local/bin/brew; and eval (/usr/local/bin/brew shellenv)
        set -e PATH[1 2]

    case Linux
	test -d ~/.linuxbrew; and eval (~/.linuxbrew/bin/brew shellenv)
	test -d /home/linuxbrew/.linuxbrew; and eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

    case Windows_NT
	# Print OS Identifier
	test -d /cygdrive; and echo $OS (uname -o); or echo $OS
end

end
