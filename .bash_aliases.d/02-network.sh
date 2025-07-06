##########################
#  🌐 Alias de red y puertos
##########################
# Alias para tareas de red, puertos y conectividad
alias netports='netstat -tulanp'
alias myip="curl http://ipinfo.io/ip"
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ping='ping -c 10'

##########################
#  📚 Alias de VPN y pentesting
##########################
# Alias para conexiones VPN y herramientas de pentesting
alias vpn_thm='sudo openvpn ~/Documentos/TryHackme/conexion/okud4.ovpn'
alias vpn_htb='sudo openvpn ~/Documentos/HTB/Conexion/okud4htb.ovpn'
alias pyhttp='python3 -m http.server'
alias nclisten='rlwrap nc -lvnp 7777'
alias rcatlisten='rcat listen -ib 7777'
