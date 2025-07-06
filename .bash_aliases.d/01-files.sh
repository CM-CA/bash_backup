##########################
#  📚 Alias de archivos y directorios
##########################
# Alias para listar, buscar y manipular archivos y carpetas
alias ls='lsd --color=auto'
alias la='lsd -a'
alias lsx='lsd -lXh'      # Ordenar por extensión
alias lssize='lsd -lSrh'  # Ordenar por tamaño
alias lsrec='lsd -lRh'    # Recursivo
alias lsdate='lsd -ltrh'  # Ordenar por fecha
alias lsmore='lsd -alh | more'
alias lsdetailed='lsd -alFh' # Detallado
alias lsfiles="lsd -l | grep -E -v '^d'" # Solo archivos
alias lsdirs="lsd -l | grep -E '^d' --color=never" # Solo carpetas
alias lsd='lsd'
alias lsdots="lsd -A | grep -E '^\.' --color=never"
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias cd..='cd ..' # Corrección de tipeo
alias pdw='pwd'    # Corrección de tipeo
alias cls='clear'
