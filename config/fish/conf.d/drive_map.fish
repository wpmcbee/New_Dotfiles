
if test -d /cygdrive;
    function c:
	cd /cygdrive/c
    end

    function d:
	test -d /cygdrive/d; and cd /cygdrive/d; or echo "D: not mounted"
    end

    function e:
	test -d /cygdrive/e; and cd /cygdrive/e; or echo "E: not mounted"
    end

    function f:
	test -d /cygdrive/f; and cd /cygdrive/f; or echo "F: not mounted"
    end

    function g:
	test -d /cygdrive/g; and cd /cygdrive/g; or echo "G: not mounted"
    end

else if test -d /Volumes
    # My Book mount on MacOS
    function f:
	test -d /Volumes/My\ Book; and cd /Volumes/My\ Book; or echo "My Book not mounted"
    end

end
