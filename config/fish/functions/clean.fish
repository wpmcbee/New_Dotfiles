function clean
    bash -c "rm -i [%~#^,]* .*.{OLD,BAK,bak,backup} *.{OLD,BAK,bak,backup} *[%~#^,] .*[%~#^,] core*"
end
