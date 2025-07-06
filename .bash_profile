# ~/.bash_profile

# Iniciar entorno interactivo si es login shell
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Variables de entorno adicionales para herramientas comunes
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin"

# Configuración de GPG
export GPG_TTY=$(tty)

# Evitar errores con herramientas que dependen de locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Iniciar tmux automáticamente si está instalado y no dentro de tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach || tmux new-session
fi

#Pyenv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
