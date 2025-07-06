##########################
#  🛠️ Utilidades varias
##########################
# Codificación/decodificación

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

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

urlencode() {
  local string="${*}"
  local strlen=${#string}
  local encoded=""
  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * ) printf -v o '%%%02x' "'$c" ;;
     esac
     encoded+="${o}"
  done
  echo "${encoded}"
}
