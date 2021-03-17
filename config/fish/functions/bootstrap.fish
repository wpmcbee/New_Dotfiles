function bootstrap

    # OK to call bootstrap multiple times, just redundant so provide a flag
    set -U LOCAL_BOOTSTRAP 1
    set -q ANSIBLE_NOCOWS; or set -Ux ANSIBLE_NOCOWS 1
    # setting OS from uname can be wrong if running Cygwin
    # fish should have already set it correctly
    set -q OS; or set -Ux OS (uname)
    set -Ux CDPATH . $HOME

    abbr -a -U gco 'git checkout'

    switch $OS
	case Darwin
	    abbr -a -U em 'open -b org.gnu.emacs'
            set -Ux EDITOR emacsclient
            set -Ux ALTERNATE_EDITOR "open -b org.gnu.emacs"
            set -Ux OMPI_CPPFLAGS "-I/usr/local/include"
	    set -Ux OMPI_LDFLAGS "-L/usr/local/lib"
	    set -Ux CPPFLAGS "-I/usr/local/include"
	    set -Ux LDFLAGS "-L/usr/local/lib"

	case Linux
	    # Windows Subsytem for Linux provides /mnt/c for C:
	    set -q WSLENV; and abbr -a -U c: 'cd "/mnt/c"'
	    # Parallels provides /media/psf/Home for access to Mac Home
	    test -d /media/psf/Home; and abbr -a -U xyzzy 'cd "/media/psf/Home"'

	case Windows_NT
	    # Test if running Cygwin
	    if test -d /cygdrive;
		# Skyrim and Tales of Two Wastelands
		test -d /cygdrive/d/SteamLibrary; and abbr -a -U SSE: cd\ /cygdrive/d/SteamLibrary/steamapps/common/Skyrim\\\ Special\\\ Edition
		test -d /cygdrive/d/SSE_MO2; and abbr -a -U mods 'cd /cygdrive/d/SSE_MO2/mods/'
		test -d /cygdrive/d/TTW_MO2; and abbr -a -U ttw 'cd /cygdrive/d/TTW_MO2/mods/'
		abbr -a -U xyzzy 'cd (cygpath $HOMEPATH)'
		set -aUx CDPATH (cygpath $HOMEPATH)
	    else
		echo "Windows without Cygwin?"
	    end

	case "*"
	    echo "Unrecognized operating system $OS"
    end
end
