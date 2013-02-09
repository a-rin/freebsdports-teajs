#FreeBSD ports: teajs
##BUILD&INSTALL
    # make
    # make install
    # cd /usr/local/etc
    # cp teajs.conf.dist teajs.conf
    # /usr/local/etc/rc.d/apache22 restart

##UNINSTALL
    # make deinstall
    # /usr/local/etc/rc.d/apache22 restart

##Tested Environment
FreeBSD stable/9 amd64

##TODO
- Makefile: options
- src/lib/xdom: cant compile

