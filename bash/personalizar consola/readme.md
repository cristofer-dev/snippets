# Debian 8.8
## Mostrar ramas de git en el prompt

> Se llama prompt al carácter o conjunto de caracteres que se muestran en una línea de comandos para indicar que está a la espera de órdenes. Éste puede variar dependiendo del intérprete de comandos y suele ser configurable. [Wiki](https://es.wikipedia.org/wiki/Prompt)

En el archivo `.bashrc` que esta en la ruta `~/.bashrc` lo editamos con nano
`nano ~/.bashrc`
Buscamos las siguientes lineas
``` 
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\ $ '
fi
```
Las editamos y las dejamos de la siguiente manera:

```
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
 
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\[\033[33m\]$(parse_git_branch)\[\033[00m\] $ '
fi
```
- `parse_git_branch` : Función que evalua si el directorio tiene ramas de git y nos retorna el nombre de la rama actual
- `\[\033[33m\]`: Setea el color de texto siguiente en `amarillo`
- `\[\033[00m\]`: Setea el color de texto siguiente en `NO_COLOUR`

referencias:
- [Bash Prompt Colors](http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)
