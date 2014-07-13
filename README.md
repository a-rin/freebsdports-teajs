#FreeBSD ports: teajs
##BUILD&INSTALL
    # make
    # make install
    # /usr/local/etc/rc.d/apache22 restart

##UNINSTALL
    # make deinstall
    # /usr/local/etc/rc.d/apache22 restart

##Tested Environment
- FreeBSD stable/9 amd64

##TODO
- src/lib/xdom: cant compile
- Makefile: option FCGI and MODULE are exclusive
