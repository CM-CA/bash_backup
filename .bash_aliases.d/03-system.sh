##########################
#  🖥️ Alias de edición y sistema
##########################
# Alias para edición rápida, actualización y utilidades del sistema
alias editbashrc="sudo ${EDITOR:-nano} ~/.bashrc"
if [ -f /etc/arch-release ]; then
  alias upgrade='sudo pacman -Syu'
elif [ -f /etc/debian_version ]; then
  alias upgrade='sudo apt update && sudo apt upgrade -y'
else
  alias upgrade='echo "No se reconoce la distribución para upgrade"'
fi
alias grep='grep --color=auto'
if [[ $- == *i* ]]; then
  alias cat='bat'
fi
alias less='less -R'

##########################
#  📚 Alias de portapapeles
##########################
# Alias para copiar contenido al portapapeles
alias copyfile='xclip < '
