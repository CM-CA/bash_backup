# ~/.bash_aliases (loader principal)
# ¡No edites alias ni funciones aquí! Usa los archivos en ~/.bash_aliases.d/

# Cargar todos los alias y funciones modulares
if [ -d "$HOME/.bash_aliases.d" ]; then
  for f in "$HOME/.bash_aliases.d/"*.sh; do
    [ -r "$f" ] && source "$f"
  done
fi

