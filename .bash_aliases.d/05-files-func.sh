##########################
#  📦 Funciones de archivos
##########################
extract() {
    if [ -f "$1" ]; then
        case $1 in
        *.tar.bz2)   tar -xvjf  $1    ;;
        *.tar.gz)    tar -xvzf  $1    ;;
        *.tar.xz)    tar -xvJf  $1    ;;
        *.bz2)       bunzip2    $1    ;;
        *.rar)       rar x      $1    ;;
        *.gz)        gunzip     $1    ;;
        *.tar)       tar -xvf   $1    ;;
        *.tbz2)      tar -xvjf  $1    ;;
        *.tgz)       tar -xvzf  $1    ;;
        *.zip)       unzip      $1    ;;
        *.Z)         uncompress $1    ;;
        *.7z)        7z x       $1    ;;
        *)           echo "Don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

compress() {
    if [ -n "$1" ]; then
        FILE=$1
        shift
        case $FILE in
        *.tar) tar -cf $FILE "$@" ;;
        *.tar.bz2) tar -cjf $FILE "$@" ;;
        *.tar.xz) tar -cJf $FILE "$@" ;;
        *.tar.gz) tar -czf $FILE "$@" ;;
        *.tgz) tar -czf $FILE "$@" ;;
        *.zip) zip $FILE "$@" ;;
        *.rar) rar a $FILE "$@" ;;
        *) echo "Formato no soportado: $FILE" ;;
        esac
    else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}
