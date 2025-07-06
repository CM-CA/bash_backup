# ~/.bash_aliases.d

**Estructura modular de alias y funciones Bash**

Este directorio contiene todos los alias y funciones personalizados, organizados por temática para facilitar su mantenimiento, portabilidad y reutilización.

## ¿Cómo funciona?
- El archivo principal `~/.bash_aliases` solo carga automáticamente todos los scripts `.sh` de este directorio, en orden numérico/alfabético.
- Puedes añadir, editar o desactivar alias y funciones simplemente modificando los archivos aquí.
- Para desactivar un grupo, renombra el archivo o ponle extensión distinta a `.sh`.

## Archivos incluidos
- **01-files.sh**: Alias para archivos y directorios (ls, la, lsd, etc.)
- **02-network.sh**: Alias de red, puertos, VPN y utilidades de conectividad
- **03-system.sh**: Alias de sistema, edición, actualización y portapapeles
- **04-pentest.sh**: Funciones y alias de pentesting/red (Nmap, ffuf, etc.)
- **05-files-func.sh**: Funciones para extraer y comprimir archivos
- **06-utils.sh**: Funciones de codificación/decodificación y utilidades varias
- **99-aliashelp.sh**: Función `aliashelp` para consultar y buscar alias/funciones

## Uso
- Edita solo los archivos dentro de este directorio.
- Para ver todos tus alias y funciones: `aliashelp`
- Para ver la descripción/comando de un alias/función: `aliashelp -d <nombre>`

## Ejemplo de carga automática
El archivo `~/.bash_aliases` contiene:
```bash
if [ -d "$HOME/.bash_aliases.d" ]; then
  for f in "$HOME/.bash_aliases.d/"*.sh; do
    [ -r "$f" ] && source "$f"
  done
fi
```

---

**¡Organiza y mantén tu entorno Bash como un pro!**
