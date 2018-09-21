Buscar un archivo en el historial
```
git log --all --full-history -- **/thefile.* 
```

Remover un archivo de cada confirmación
```bash
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
```

[mas info](https://git-scm.com/book/es/v2/Herramientas-de-Git-Reescribiendo-la-Historia)
