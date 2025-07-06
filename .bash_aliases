##########################
#  📚 Alias comunes
##########################

# 📌 Listar archivos (lsd)
alias ls='lsd --color=auto'
alias la='lsd -a'
alias lx='lsd -lXh' # 📌 Ordenar por extensión
alias lk='lsd -lSrh' # 📌 Ordenar por tamaño
alias lr='lsd -lRh' # 📌 Recursivo
alias lt='lsd -ltrh' # 📌 Ordenar por fecha
alias lm='lsd -alh | more'
alias ll='lsd -alFh' # 📌 Detallado
alias lf="lsd -l | grep -E -v '^d'" # 📌 Solo archivos
alias ldir="lsd -l | grep -E '^d' --color=never" # 📌 Solo carpetas
alias l='lsd'
alias l.="lsd -A | grep -E '^\.' --color=never"

# 📌 Puertos y red
alias ports='netstat -tulanp'
alias myip="curl http://ipinfo.io/ip"
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"

# 📌 Edición y sistema
alias nb="sudo $EDITOR ~/.bashrc"
alias upgrade="sudo apt update && sudo apt upgrade -y"
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias grep='grep --color=auto'
alias cat='bat'
alias cd..='cd ..'
alias pdw='pwd'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'

# 📌 Copiar contenido al portapapeles
alias cpc='xclip < '

##########################
#  📚 VPN
##########################

# 📌 Conectar VPN TryHackMe
alias thmvpn='sudo openvpn ~/Documentos/TryHackme/conexion/okud4.ovpn'

# 📌 Conectar VPN Hack The Box
alias htbvpn='sudo openvpn ~/Documentos/HTB/Conexion/okud4htb.ovpn'

##########################
#  📚 Pentesting y red
##########################

# 📌 Servidor HTTP en Python
alias server='python3 -m http.server'

# 📌 Netcat en escucha con rlwrap
alias listenet='rlwrap nc -lvnp 7777'

# 📌 Rcat en escucha
alias listenrust='rcat listen -ib 7777'

##########################
#  📚 Funciones personalizadas
##########################

# 📌 Escaneo solo de puertos con Nmap
nmap_ports_only() {
    if [ -z "$1" ]; then
        echo "Uso: nmap_ports_only <IP>"
        return 1
    fi
    echo "[*] Escaneando puertos abiertos en $1..."
    nmap -p- --open --min-rate=500 -T4 $1 -oG $1-openports.grep -vvv
    echo "[*] Resultado guardado en $1-openports.grep"
}

# 📌 Escaneo básico Nmap
nmap_basic_scan() {
    if [ -z "$1" ]; then
        echo "Uso: nmap_basic_scan <IP>"
        return 1
    fi
    echo "[*] Realizando escaneo básico a $1..."
    nmap -sC -sV -Pn $1 -oN $1-basic.txt -vvv
    echo "[*] Resultado guardado en $1-basic.txt"
}

# 📌 Escaneo paranoico Nmap
nmap_paranoid_scan() {
    if [ -z "$1" ]; then
        echo "Uso: nmap_paranoid_scan <IP>"
        return 1
    fi
    echo "[*] Escaneo en modo paranoico contra $1..."
    sudo nmap -sS -sV -sC -A -T0 -f --data-length 24 --max-retries 1 --version-all $1 -oN $1-paranoid.txt -vvv
    echo "[*] Resultado guardado en $1-paranoid.txt"
}

# 📌 Extraer puertos de resultado Nmap
# 📌 Extraer puertos de archivo .gnmap o .grepable
extractPorts() {
    if [[ -z "$1" ]]; then
        echo "Uso: extractPorts <archivo>"
        return 1
    fi

    # Extraer puertos abiertos en CSV
    ports=$(grep -oP '\d+/open' "$1" | cut -d '/' -f 1 | sort -n | uniq | tr '\n' ',' | sed 's/,$//')

    # Extraer IP
    ip_address=$(grep -oP '\d+\.\d+\.\d+\.\d+' "$1" | sort -u | head -n 1)

    # Mostrar resultados
    echo -e "\n[*] Extrayendo información...\n" > extractPorts.tmp
    echo -e "\t[*] Dirección IP: $ip_address" >> extractPorts.tmp
    echo -e "\t[*] Puertos abiertos: $ports\n" >> extractPorts.tmp

    # Copiar al portapapeles
    echo -n "$ports" | xclip -sel clip

    echo -e "[*] Puertos copiados al portapapeles\n" >> extractPorts.tmp
    cat extractPorts.tmp
    rm extractPorts.tmp
}


# 📌 Crear estructura de carpetas pentest
mkt() {
    if [[ $# -ne 2 ]]; then
        echo "Uso: mkt <HTB|THM> <nombre_maquina>"
        return 1
    fi
    local plataforma=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local nombre_maquina=$2
    local base_dir=~/Documentos
    case "$plataforma" in
        HTB|THM)
            local ruta="$base_dir/$plataforma/maquinas/$nombre_maquina"
            ;;
        *)
            echo "Plataforma no reconocida. Usa HTB o THM."
            return 1
            ;;
    esac
    echo "[+] Creando estructura para $nombre_maquina en $plataforma..."
    mkdir -p "$ruta"/{scan,content,exploits,apuntes}
    cd "$ruta/scan" || return
    echo "[+] Estructura creada. Ahora estás en '$ruta/scan'"
}

# 📌 Añadir entrada en /etc/hosts
addhost() {
    if [ $# -ne 2 ]; then
        echo "Uso: addhost <IP> <dominio>"
        return 1
    fi
    echo "$1 $2" | sudo tee -a /etc/hosts > /dev/null
    echo "Añadido: $1 $2"
}

# 📌 Extraer varios tipos de archivos
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

# 📌 Comprimir archivos
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

# 📌 Servidor HTTP en Python (enhanced)
pyserve() {
  local port=${1:-8000}
  echo "HTTP server running at: http://$(hostname -I | awk '{print $1}'):$port"
  python3 -m http.server "$port"
}

# 📌 Servidor PHP
servephp() {
  local port=${1:-8000}
  echo "PHP server running at: http://$(hostname -I | awk '{print $1}'):$port"
  php -S 0.0.0.0:"$port"
}

# 📌 Escaneo avanzado Nmap
nmap_scan() {
    if [ -z "$1" ]; then
        echo -e "\n\e[1;31m[!] Uso: nmap_scan <target> [puertos] [opciones]\e[0m"
        return 1
    fi
    local target=$1
    local ports=${2:-"-p-"}
    local extra_args=${3:-""}
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local output_file="nmap_scan_${target}_${timestamp}"
    sudo nmap -sS -sV -sC -O ${ports} ${extra_args} \
        -T4 --min-rate 1000 --max-retries 2 \
        -Pn -vvv --open --script-timeout 2m \
        -oA ${output_file} ${target}
    ls -lh ${output_file}.*
    grep -P '^\d+/tcp.*open' ${output_file}.nmap | sort -n | awk '{print "\t"$1,$2,$3}'
}

# 📌 Fuzzing con ffuf
ffuf_scan() {
  [ -z "$1" ] && echo "Uso: ffuf_scan <url> <wordlist>" && return
  ffuf -w "${2:-/usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt}" -u "$1/FUZZ" -c -t 100
}

# 📌 Decodificar
decode() {
  [ -z "$1" ] && echo "Uso: decode <string> [base64|hex|url]" && return
  local type=${2:-base64}
  case $type in
    base64) echo "$1" | base64 -d ;;
    hex) echo "$1" | xxd -p -r ;;
    url) echo "$1" | urldecode ;;
    *) echo "Unsupported type: $type" ;;
  esac
}

# 📌 Codificar
encode() {
  [ -z "$1" ] && echo "Uso: encode <string> [base64|hex|url]" && return
  local type=${2:-base64}
  case $type in
    base64) echo "$1" | base64 ;;
    hex) echo "$1" | xxd -p ;;
    url) echo "$1" | urlencode ;;
    *) echo "Unsupported type: $type" ;;
  esac
}

# 📌 URL decode
urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

# 📌 URL encode
urlencode() {
  local string="${*}"
  local strlen=${#string}
  local encoded=""
  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * ) printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"
}

# 📌 Obtener subdominios de crt.sh
crtsh() {
  [ -z "$1" ] && echo "Uso: crtsh <domain>" && return
  curl -s "https://crt.sh/?q=%25.$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
}

##########################
#  📚 aliashelp
##########################

# 📌 Mostrar lista de alias y funciones con su descripción
aliashelp() {
    local filtro=$1
    local archivo=~/.bash_aliases
    echo -e "\n\033[1;36m📚 Alias definidos:\033[0m"
    awk -v filtro="$filtro" '
    BEGIN { comment="" }
    {
        if ($0 ~ /^#/) { comment = $0 }
        if ($0 ~ /^alias /) {
            if (filtro == "" || tolower($0) ~ tolower(filtro) || tolower(comment) ~ tolower(filtro)) {
                if (comment != "") {
                    printf "\033[1;33m%s\033[0m\n", comment
                }
                gsub(/^alias /, "  ", $0)
                gsub(/='\''/, " -> '\''", $0)
                print $0 "\n"
            }
            comment=""
        }
    }' "$archivo"
    echo -e "\n\033[1;36m📚 Funciones definidas:\033[0m"
    awk -v filtro="$filtro" '
    BEGIN { comment="" }
    {
        if ($0 ~ /^#/) { comment = $0 }
        if ($0 ~ /^[a-zA-Z0-9_]+\(\)[[:space:]]*\{/ ) {
            func_name = $1
            sub(/\(\).*/, "", func_name)
            if (filtro == "" || tolower(func_name) ~ tolower(filtro) || tolower(comment) ~ tolower(filtro)) {
                if (comment != "") {
                    printf "\033[1;33m%s\033[0m\n", comment
                }
                printf "  %s -> función definida\n\n", func_name
            }
            comment=""
        }
    }' "$archivo"
}

# 📌 Alias rápido para aliashelp
alias ah='aliashelp'

