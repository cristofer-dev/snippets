#!/bin/bash
#===============================================================================
#    JackTheStripper v 2.5
#    Official Version for deploy a Debian GNU/Linux server, version 7 (or more)

#    Developed by Eugenia Bahit <eugenia@linux.com>
#    
#    Copyright © 2013, 2014, 2015 Eugenia Bahit <eugenia@linux.com>
#    License: GNU GPL version 3  <http://gnu.org/licenses/gpl.html>.
#    This is free software: you are free to change and redistribute it.
#    There is NO WARRANTY, to the extent permitted by law.
#===============================================================================


source helpers.sh
declare -r optional_arg="$1"


# 0. Verificar si es usuario root o no 
function is_root_user() {
    if [ "$USER" != "root" ]; then
        echo "Permiso denegado."
        echo "Este programa solo puede ser ejecutado por el usuario root"
        exit
    else
        clear
        cat templates/texts/welcome
    fi
}


# 1. Configurar Hostname
function set_hostname() {
    write_title "1. Configurar Hostname"
    echo -n " ¿Desea configurar un hostname? (y/n): "; read config_host
    if [ "$config_host" == "y" ]; then
        serverip=$(__get_ip)
        echo " Ingrese un nombre para identificar a este servidor"
        echo -n " (por ejemplo: myserver) "; read host_name
        echo -n " ¿Cuál será el dominio principal? "; read domain_name
        echo $host_name > /etc/hostname
        hostname -F /etc/hostname
        echo "127.0.0.1    localhost.localdomain      localhost" >> /etc/hosts
        echo "$serverip    $host_name.$domain_name    $host_name" >> /etc/hosts
    fi
    say_done
}


# 2. Configurar zona horaria
function set_hour() {
    write_title "2. Configuración de la zona horaria"
    dpkg-reconfigure tzdata
    say_done
}


#  3. Actualizar el sistema
function sysupdate() {
    write_title "3. Actualización del sistema"
    apt-get update
    apt-get upgrade -y
    say_done
}


#  4. Crear un nuevo usuario con privilegios
function set_new_user() {
    write_title "4. Creación de un nuevo usuario"
    echo -n " Indique un nombre para el nuevo usuario: "; read username
    adduser $username
    say_done
}


#  5. Instrucciones para generar una RSA Key
function give_instructions() {
    serverip=$(__get_ip)
    write_title "5. Generación de llave RSA en su ordenador local"
    echo " *** SI NO TIENE UNA LLAVE RSA PÚBLICA EN SU ORDENADOR, GENERE UNA ***"
    echo "     Siga las instrucciones y pulse INTRO cada vez que termine una"
    echo "     tarea para recibir una nueva instrucción"
    echo " "
    echo "     EJECUTE LOS SIGUIENTES COMANDOS:"
    echo -n "     a) ssh-keygen "; read foo1
    echo -n "     b) scp .ssh/id_rsa.pub $username@$serverip: "; read foo2
    say_done
}


#  6. Mover la llave pública RSA generada
function move_rsa() {
    write_title "6. Se moverá la llave pública RSA generada en el paso 5"
    mkdir /home/$username/.ssh
    mv /home/$username/id_rsa.pub /home/$username/.ssh/authorized_keys
    chmod 700 /home/$username/.ssh
    chmod 600 /home/$username/.ssh/authorized_keys
    chown -R $username:$username /home/$username/.ssh
    say_done
}


#  7. Securizar SSH
function ssh_reconfigure() {
    write_title "7. Securizar accesos SSH"
    sed s/USERNAME/$username/g templates/sshd_config > /etc/ssh/sshd_config
    service ssh restart
    say_done
}


#  8. Establecer reglas para iptables
function set_iptables_rules() {
    write_title "8. Establecer reglas para iptables (firewall)"
    cat templates/iptables > /etc/iptables.firewall.rules
    iptables-restore < /etc/iptables.firewall.rules
    say_done
}


#  9. Crear script de automatizacion iptables
function create_iptable_script() {
    write_title "9. Crear script de automatización de reglas de iptables tras reinicio"
    cat templates/firewall > /etc/network/if-pre-up.d/firewall
    chmod +x /etc/network/if-pre-up.d/firewall
    say_done
}


# 10. Instalar fail2ban
function install_fail2ban() {
    # para eliminar una regla de fail2ban en iptables utilizar:
    # iptables -D fail2ban-ssh -s IP -j DROP
    write_title "10. Instalar Sendmail y fail2ban"
    apt-get install sendmail-bin -y
    apt-get install sendmail -y
    apt-get install fail2ban -y
    say_done
}


# 11. Instalar, Configurar y Optimizar MySQL
function install_mysql() {
    write_title "11. Instalar MySQL"
    apt-get install mysql-server -y
    echo -n " configurando MySQL............ "
    cp templates/mysql /etc/mysql/my.cnf; echo " OK"
    mysql_secure_installation
    service mysql restart
    say_done
}


# 12. Instalar, configurar y optimizar PHP
function install_php() {
    write_title "12. Instalar PHP 5 + Apache 2"
    apt-get install php5 php-pear -y
    apt-get install php5-mysql -y
    echo -n " reemplazando archivo de configuración php.ini..."
    cp templates/php /etc/php5/apache2/php.ini; echo " OK"
    service apache2 restart
    mkdir /srv/websites
    chown -R $username:$username /srv/websites
    write_title "Aloje sus WebApps en el directorio /srv/websites"
    echo "Si desea alojar sus aplicaciones en otro directorio, por favor, "
    echo "establezca la nueva ruta en la directiva open_base del archivo "
    echo "/etc/php5/apache2/php.ini"
    say_done
}


# 13. Instalar ModSecurity
function install_modsecurity() {
    write_title "13. Instalar ModSecurity"
    apt-get install libxml2 libxml2-dev libxml2-utils -y
    apt-get install libaprutil1 libaprutil1-dev -y
    apt-get install libapache-mod-security -y

    service apache2 restart
    say_done
}


# 14. Instalar OWASP para ModSecuity
function install_owasp_core_rule_set() {
    write_title "14. Instalar OWASP ModSecurity Core Rule Set"

    echo -n " descargar........................................................ "
    uri_part1='http://pkgs.fedoraproject.org/repo/pkgs/mod_security_crs/'
    uri_part2='modsecurity-crs_2.2.5.tar.gz'
    uri_part3='aaeaa1124e8efc39eeb064fb47cfc0aa/modsecurity-crs_2.2.5.tar.gz'
    wget $uri_part1/$uri_part2/$uri_part3; echo "OK"

    echo -n " desempaquetar.................................................... "
    tar -xzf modsecurity-crs_2.2.5.tar.gz; echo "OK"

    echo -n " mover............................................................ "
    cp -R modsecurity-crs_2.2.5/* /etc/modsecurity/; echo "OK"

    echo -n " eliminar archivos temporales..................................... "
    rm modsecurity-crs_2.2.5.tar.gz
    rm -R modsecurity-crs_2.2.5; echo "OK"

    echo -n " configurar....................................................... "
    from_path="/etc/modsecurity/modsecurity_crs_10_setup.conf.example"
    to_path="/etc/modsecurity/modsecurity_crs_10_setup.conf"
    mv $from_path $to_path

    for archivo in /etc/modsecurity/base_rules/*
        do ln -s $archivo /etc/modsecurity/activated_rules/
    done

    for archivo in /etc/modsecurity/optional_rules/*
        do ln -s $archivo /etc/modsecurity/activated_rules/
    done
    echo "OK"

    modsecrec="/etc/modsecurity/modsecurity.conf-recommended"
    sed s/SecRuleEngine\ DetectionOnly/SecRuleEngine\ On/g $modsecrec > salida
    mv salida /etc/modsecurity/modsecurity.conf
    
    if [ "$optional_arg" == "--custom" ]; then
        echo -n "Firma servidor: "; read firmaserver
        echo -n "Powered: "; read poweredby
    else
        firmaserver="Oracle Solaris 11.2"
        poweredby="n/a"
    fi
    
    modseccrs10su="/etc/modsecurity/modsecurity_crs_10_setup.conf"
    echo "SecServerSignature \"$firmaserver\"" >> $modseccrs10su
    echo "Header set X-Powered-By \"$poweredby\"" >> $modseccrs10su

    a2enmod headers
    service apache2 restart
    say_done
}


# 15. Configurar y optimizar Apache
function configure_apache() {
    write_title "15. Finalizar configuración y optimización de Apache"
    cp templates/apache /etc/apache2/apache2.conf
    echo " -- habilitar ModRewrite"
    a2enmod rewrite
    service apache2 restart
    say_done
}


# 16. Instalar ModEvasive
function install_modevasive() {
    write_title "16. Instalar ModEvasive"
    echo -n " Indique e-mail para recibir alertas: "; read inbox
    apt-get install libapache2-mod-evasive -y
    mkdir /var/log/mod_evasive
    chown www-data:www-data /var/log/mod_evasive/
    modevasive="/etc/apache2/mods-available/mod-evasive.conf"
    sed s/MAILTO/$inbox/g templates/mod-evasive > $modevasive
    a2enmod mod-evasive
    service apache2 restart
    say_done
}


# 17. Configurar fail2ban
function config_fail2ban() {
    write_title "17. Finalizar configuración de fail2ban"
    sed s/MAILTO/$inbox/g templates/fail2ban > /etc/fail2ban/jail.local
    cp /etc/fail2ban/jail.local /etc/fail2ban/jail.conf
    /etc/init.d/fail2ban restart
    say_done
}


# 18. Instalación de paquetes adicionales
function install_aditional_packages() {
    write_title "18. Instalación de paquetes adicionales"
    echo "18.1. Instalar Bazaar..........."; apt-get install bzr -y
    echo "18.2. Instalar tree............."; apt-get install tree -y
    echo "18.3. Instalar Python-MySQLdb..."; apt-get install python-mysqldb -y
    echo "18.4. Instalar WSGI............."; apt-get install libapache2-mod-wsgi -y
    echo "18.5. Instalar PIP.............."; apt-get install python-pip -y
    echo "18.6. Instalar Vim.............."; apt-get install vim -y
    echo "18.7. Instalar PHPUnit..........";
    
    wget https://phar.phpunit.de/phpunit.phar
    chmod +x phpunit.phar
    mv phpunit.phar /usr/local/bin/phpunit
    resultado=`phpunit --version`
    echo "
    
    $resultado
    
    ";
    say_done
}


# 19. Tunnear el archivo .bashrc
function tunning_bashrc() {
    write_title "19. Reemplazar .bashrc"
    cp templates/bashrc-root /root/.bashrc
    cp templates/bashrc-user /home/$username/.bashrc
    chown $username:$username /home/$username/.bashrc
    say_done
}


# 20. Tunnear Vim
function tunning_vim() {
    write_title "20. Tunnear Vim"
    tunning vimrc
}


# 21. Tunnear Nano
function tunning_nano() {
    write_title "21. Tunnear Nano"
    tunning nanorc
}


# 22. Agregar tarea de actualización diaria
function add_updating_task() {
    write_title "22. Agregar tarea de actualización diaria al Cron"
    tarea="@daily apt-get update; apt-get dist-upgrade -y"
    crontab -l > tareas
    echo $tarea >> tareas
    crontab tareas
    rm tareas
    say_done
}


# 23. Agregar comandos personalizados
function add_commands() {
    write_title "23. Agregar comandos personalizados"
    add_command_blockip     # Agregar regla bloqueo a iptables
    add_command_vhostadd    # Agregar nuevo VirtualHost
    add_command_europio     # Instalar o actualizar Europio Engine
    say_done
}


# 24. Instalar PortSentry
function install_portsentry() {
    write_title "24. Instalar y configurar el antiscan de puertos PortSentry"
    apt-get install portsentry -y
    mv /etc/portsentry/portsentry.conf /etc/portsentry/portsentry.conf-original
    cp templates/portsentry /etc/portsentry/portsentry.conf
    sed s/tcp/atcp/g /etc/default/portsentry > salida.tmp
    mv salida.tmp /etc/default/portsentry
    /etc/init.d/portsentry restart
    say_done
}


# 25. Asegurar Kernel contra ataques de red
function kernel_config() {
    "
    "
    write_title "25. Asegurar Kernel contra ataques de red"
    cp templates/sysctl /etc/sysctl.conf
    sysctl -e -p
    say_done
}


# 26. Reiniciar servidor
function final_step() {
    write_title "25. Finalizar deploy"
    replace USERNAME $username SERVERIP $serverip < templates/texts/bye
    echo -n " ¿Ha podido conectarse por SHH como $username? (y/n) "
    read respuesta
    if [ "$respuesta" == "y" ]; then
        reboot
    else
        echo "El servidor NO será reiniciado y su conexión permanecerá abierta."
        echo "Bye."
    fi
}


set_pause_on                    #  Configurar modo de pausa entre funciones


is_root_user                    #  0. Verificar si es usuario root o no
set_hostname                    #  1. Configurar Hostname
set_hour                        #  2. Configurar zona horaria
sysupdate                       #  3. Actualizar el sistema
set_new_user                    #  4. Crear un nuevo usuario con privilegios
give_instructions               #  5. Instrucciones para generar una RSA Key
move_rsa                        #  6. Mover la llave pública RSA generada
ssh_reconfigure                 #  7. Asegurar SSH
set_iptables_rules              #  8. Establecer reglas para iptables
create_iptable_script           #  9. Crear script de automatizacion iptables
install_fail2ban                # 10. Instalar fail2ban
install_mysql                   # 11. Instalar, Configurar y Optimizar MySQL
install_php                     # 12. Instalar, configurar y optimizar PHP
install_modsecurity             # 13. Instalar ModSecurity
install_owasp_core_rule_set     # 14. Instalar OWASP para ModSecuity
configure_apache                # 15. Configurar y optimizar Apache
install_modevasive              # 16. Instalar ModEvasive
config_fail2ban                 # 17. Configurar fail2ban
install_aditional_packages      # 18. Instalación de paquetes adicionales
tunning_bashrc                  # 19. Tunnear el archivo .bashrc
tunning_vim                     # 20. Tunnear Vim
tunning_nano                    # 21. Tunnear Nano
add_updating_task               # 22. Agregar tarea de actualización diaria
add_commands                    # 23. Agregar comandos personalizados
install_portsentry              # 24. Instalar PortSentry
kernel_config                   # 25. Asegurar kernel contra ataques de red
final_step                      # 26. Reiniciar servidor

