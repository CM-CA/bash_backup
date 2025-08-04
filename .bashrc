# ~/.bashrc

# Fuente de alias y funciones personalizadas
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Historial de comandos más útil
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export PAYLOADS="/usr/share/payloads"
export SECLISTS="$PAYLOADS/seclists"
export PAYLOADSALLTHETHINGS="$PAYLOADS/payloadsallthethings"
export FUZZDB="$PAYLOADS/fuzzdb"
export AUTOWORDLISTS="$PAYLOADS/autowordlists"
export SECURITYWORDLIST="$PAYLOADS/security-wordlist"

export MIMIKATZ="/usr/share/windows/mimikatz/"
export POWERSPLOIT="/usr/share/windows/powersploit/"

export ROCKYOU="$SECLISTS/Passwords/Leaked-Databases/rockyou.txt"
export DIRSMALL="$SECLISTS/Discovery/Web-Content/directory-list-2.3-small.txt"
export DIRMEDIUM="$SECLISTS/Discovery/Web-Content/directory-list-2.3-medium.txt"
export DIRBIG="$SECLISTS/Discovery/Web-Content/directory-list-2.3-big.txt"
export WEBAPI_COMMON="$SECLISTS/Discovery/Web-Content/api/api-endpoints.txt"
export WEBAPI_MAZEN="$SECLISTS/Discovery/Web-Content/common-api-endpoints-mazen160.txt"
export WEBCOMMON="$SECLISTS/Discovery/Web-Content/common.txt"
export WEBPARAM="$SECLISTS/Discovery/Web-Content/burp-parameter-names.txt"

# Colores útiles
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# 🐍 Muestra entorno pyenv si está activo
pyenv_prompt() {
  command -v pyenv >/dev/null || return
  local venv=$(pyenv version-name 2>/dev/null)
  [ "$venv" != "system" ] && echo "🐍($venv)"
}

# 🎯 Setear IP + nombre de máquina como objetivo
setarget() {
  if [[ $# -ne 2 ]]; then
    echo "Uso: setarget <IP> <nombre_maquina>"
    return 1
  fi
  export TARGET_IP="$1"
  export TARGET_NAME="$2"
  echo "[+] Objetivo establecido: $TARGET_NAME -> $TARGET_IP"
}

# 🔎 Obtener IPs locales (excepto loopback)
get_ip_addresses() {
  ip -4 addr | grep -v '127.0.0.1' | grep -v 'secondary' | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | tr '\n' '|' | sed 's/|$//'
}

# 🌍 IP pública con caché (seguro y sin errores)
get_cached_public_ip() {
  local cache_dir="$HOME/.cache"
  local cache_file="$cache_dir/public_ip_cache"
  local cache_duration=600  # segundos

  mkdir -p "$cache_dir"

  # Si existe y es reciente, usar caché
  if [[ -f $cache_file && $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt $cache_duration ]]; then
    cat "$cache_file"
  else
    # Silenciar errores de curl y jq
    local response
    response=$(curl -s https://api.myip.com 2>/dev/null)

    local ip
    ip=$(echo "$response" | jq -r .ip 2>/dev/null)

    # Verificar IP válida
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "$ip" >| "$cache_file"
      echo "$ip"
    else
      echo "No-IP"
    fi
  fi
}



# 🧠 Ruta compacta: muestra solo las 2 últimas carpetas del path
compact_pwd() {
  local full="$PWD"
  local compact=$(echo "$full" | awk -F'/' '{n=NF; if (n>=2) print $(n-1) "/" $n; else print $n}')
  echo "~/$compact"
}

# 🎨 Establecer prompt personalizado PRO con objetivo
set_custom_prompt() {
  local ip_local=$(get_ip_addresses)
  local ip_public=$(get_cached_public_ip)
  local cwd=$(compact_pwd)
  local venv=$(pyenv_prompt)

  local target_display=""
  if [[ -n "$TARGET_IP" && -n "$TARGET_NAME" ]]; then
    target_display="🎯 $TARGET_NAME ($TARGET_IP)"
  fi

  PS1="\[\e[1;32m\][⚔️ OKUD4] \[\e[1;36m\]\u@\h \[\e[0m\]\[\e[1;33m\]$cwd \[\e[1;35m\]$ip_local 🔥 $ip_public \[\e[1;34m\]$target_display\n\[\e[1;32m\]└╼[💀 $venv] \$ \[\e[0m\]"
}


# 🔁 Refrescar el prompt
PROMPT_COMMAND=set_custom_prompt





# Activar autocompletado (solo para compatibilidad, preferir la ruta de Arch)
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Agregar /usr/local/bin y ~/.local/bin al PATH
export PATH="$PATH:$HOME/.local/bin:/usr/local/bin"

# Editor por defecto
export EDITOR=nano

# Evitar que los scripts creen archivos de backup como nombre~
set -o noclobber
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Ruby
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin"

# Go
export PATH="$PATH:$HOME/go/bin"
