#-*- coding: utf-8 -*-
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

from sys import argv 


if __name__ == "__main__":
    try:
        print argv[2].replace("addr:", "")
    except:
        print "Argumentos insuficientes para obtener la IP del servidor"

