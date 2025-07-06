##########################
#  📚 aliashelp
##########################

# 📌 Mostrar lista de alias y funciones usando Python (modo compacto y detallado)
# Ahora busca en todos los archivos .sh de ~/.bash_aliases.d/
aliashelp() {
    local modo="compacto"
    local filtro=""
    if [[ "$1" == "-d" ]]; then
        modo="detallado"
        filtro="${2,,}"
    else
        filtro="${1,,}"
    fi
    # Validar filtro: solo letras, números y guion bajo
    if [[ -n "$filtro" && ! "$filtro" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo -e "\e[1;31m[!] Error: El filtro solo puede contener letras, números y guion bajo (sin paréntesis ni espacios).\e[0m" >&2
        return 2
    fi
    local aliasdir="$HOME/.bash_aliases.d"
    local files=( )
    if [[ -d "$aliasdir" ]]; then
        for f in "$aliasdir"/*.sh; do
            [[ -r "$f" ]] && files+=("$f")
        done
    fi
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No se encontraron archivos de alias en $aliasdir" >&2
        return 1
    fi
    python3 - "$modo" "$filtro" "${files[@]}" <<'EOF'
import sys, re
BOLD = "\033[1m"
CYAN = "\033[36m"
YELLOW = "\033[33m"
GRAY = "\033[90m"
RESET = "\033[0m"

modo = sys.argv[1]
filtro = sys.argv[2] if len(sys.argv) > 2 else ""
archivos = sys.argv[3:]

show_hint = False

def process_file(path, alias_cb, func_cb):
    last_comment = ""
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip()
            if line.startswith("#"):
                last_comment = line
            elif line.startswith("alias "):
                m = re.match(r"alias\s+([a-zA-Z0-9_]+)=(.*)", line)
                if m:
                    alias_cb(m.group(1), m.group(2).strip("'\""), last_comment)
                last_comment = ""
            elif re.match(r"^[a-zA-Z0-9_]+\(\)\s*\{", line):
                fname = line.split('(')[0]
                func_cb(fname, last_comment)
                last_comment = ""

def exact_match(name, filtro):
    return filtro and name.lower() == filtro

def partial_match(name, filtro):
    return filtro and filtro in name.lower()

if modo == "compacto":
    aliases = []
    funcs = []
    def alias_cb(name, value, comment):
        if not filtro or partial_match(name, filtro):
            aliases.append(name)
    def func_cb(fname, comment):
        if not filtro or partial_match(fname, filtro):
            funcs.append(fname)
    for archivo in archivos:
        process_file(archivo, alias_cb, func_cb)
    def print_columns(lst, title):
        if not lst:
            return
        print(f"{BOLD}{CYAN}{title}:{RESET}")
        cols = 4
        width = max((len(x) for x in lst), default=0) + 2
        for i, name in enumerate(lst):
            print(f"{name:<{width}}", end='')
            if (i+1) % cols == 0:
                print()
        if len(lst) % cols != 0:
            print()
        print()
    if not aliases and not funcs:
        print(f"{YELLOW}No se encontraron coincidencias para '{filtro}'.{RESET}")
    else:
        print_columns(aliases, "Alias")
        print_columns(funcs, "Funciones")
        show_hint = True
else:
    printed = [False]
    def alias_cb(name, value, comment):
        if not filtro:
            return
        if exact_match(name, filtro) or (not filtro):
            print(f"{BOLD}{CYAN}Alias:{RESET} {name}")
            if comment:
                print(f"  {GRAY}{comment.lstrip('# ').strip()}{RESET}")
            print(f"  {YELLOW}{value}{RESET}\n")
            printed[0] = True
    def func_cb(fname, comment):
        if not filtro:
            return
        if exact_match(fname, filtro) or (not filtro):
            print(f"{BOLD}{CYAN}Función:{RESET} {fname}()")
            if comment:
                print(f"  {GRAY}{comment.lstrip('# ').strip()}{RESET}")
            print(f"  {YELLOW}Función definida en .bash_aliases.d{RESET}\n")
            printed[0] = True
    for archivo in archivos:
        process_file(archivo, alias_cb, func_cb)
    if not printed[0]:
        print(f"{YELLOW}No se encontraron coincidencias para '{filtro}'.{RESET}")
    else:
        show_hint = True
if show_hint:
    print(f"\n{GRAY}Ejemplo: aliashelp -d <alias>{RESET}")
EOF
}
