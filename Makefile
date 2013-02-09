# $FreeBSD$

PORTNAME=	teajs
PORTVERSION=	0.9.4
CATEGORIES=	www
MASTER_SITES=	${MASTER_SITE_GOOGLE_CODE}
DISTNAME=	${PORTNAME}-${PORTVERSION}-src

MODULENAME=	mod_teajs

MAINTAINER=	hayashi@totalware.gifu.gifu.jp
COMMENT=	Server-side Javascript language and libraries

USE_SQLITE=	3
USE_MYSQL=	yes
USE_PGSQL=	yes
USE_GL=		glut glu glew
USE_APACHE=	22+
USE_SCONS=	yes
WRKSRC=		${WRKDIR}/${DISTNAME}/${PORTNAME}

LIB_DEPENDS=	gd:${PORTSDIR}/graphics/gd \
		v8:${PORTSDIR}/lang/v8 \
		memcached:${PORTSDIR}/databases/libmemcached \
		execinfo:${PORTSDIR}/devel/libexecinfo \
		xerces-c:${PORTSDIR}/textproc/xerces-c3 \
		fcgi:${PORTSDIR}/www/fcgi

SCONS_ARGS=	v8_path=${LOCALBASE}/include \
		mysql_path=${LOCALBASE}/include/mysql \
		pgsql_path=${LOCALBASE}/include/postgresql/server \
		apache_path=${LOCALBASE}/${APACHEINCLUDEDIR} \
		apr_path=${LOCALBASE}/include/apr-1 \
		xercesc_include=${LOCALBASE}/include/xercesc \
		gl_include=${LOCALBASE}/include/GL \
		libpath=${LOCALBASE}/lib/mysql \
		config_file=${PREFIX}/etc/teajs.conf \
		pgsql=1 gl=1 binary_b=1 fcgi=0 \
		xdom=0

post-configure:
	${SED} -e 's|%%PREFIX%%|${PREFIX}|' ${INSTALL_WRKSRC}/teajs.conf.posix > ${INSTALL_WRKSRC}/teajs.conf.dist

do-install:
	${INSTALL_PROGRAM} ${INSTALL_WRKSRC}/tea ${PREFIX}/bin/
	${INSTALL_DATA} ${INSTALL_WRKSRC}/teajs.conf.dist ${PREFIX}/etc/
	if [ ! -f ${PREFIX}/etc/teajs.conf ]; then \
		${CP} -p ${PREFIX}/etc/teajs.conf.dist ${PREFIX}/etc/teajs.conf; \
	fi
	${MKDIR} ${PREFIX}/lib/teajs
	${INSTALL_LIB} ${INSTALL_WRKSRC}/lib/*.so ${PREFIX}/lib/teajs/
	${INSTALL_DATA} ${INSTALL_WRKSRC}/lib/*.js ${PREFIX}/lib/teajs/
	${APXS} -i -a -n teajs ${INSTALL_WRKSRC}/mod_teajs.so
	${INSTALL_DATA} ${INSTALL_WRKSRC}/apache2/mods-available/teajs.conf ${PREFIX}/${APACHEETCDIR}/Includes/
.include <bsd.port.mk>
