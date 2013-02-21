# $FreeBSD$

PORTNAME=	teajs
PORTVERSION=	0.9.4
CATEGORIES=	www
MASTER_SITES=	${MASTER_SITE_GOOGLE_CODE}
DISTNAME=	${PORTNAME}-${PORTVERSION}-src

MODULENAME=	mod_teajs

MAINTAINER=	a.rin.mix@gmail
COMMENT=	Server-side Javascript language and libraries


OPTIONS_DEFINE=	MYSQL MEMCACHED PGSQL SQLITE GD TLS XDOM MODULE CGI
OPTIONS_DEFAULT=MYSQL SQLITE GD TLS MODULE CGI

##OPTIONS_DEFINE=	FIBERS MYSQL MEMCACHED PROFILER PGSQL SQLITE GD SOCKET \
##		PROCESS FS ZLIB TLS XDOM GL BINARY_B MODULE CGI FCGI

FIBERS_DESC=	Fiber support
MYSQL_DESC=	MySQL library
MEMCACHED_DESC=	Memcached library
PROFILER_DESC=	V8 Profiler library
PGSQL_DESC=	PostgreSQL library
SQLITE_DESC=	SQLite library
GD_DESC=	GD library
SOCKET_DESC=	Socket library
PROCESS_DESC=	Process library
FS_DESC=	Filesystem I/O library
ZLIB_DESC=	zlib library
TLS_DESC=	SSL/TLS library
XDOM_DESC=	DOM Level 3 library
GL_DESC=	OpenGL library
BINARY_B_DESC=	Build Binary/B module
MODULE_DESC=	Build Apache module
CGI_DESC=	Build CGI binary
FCGI_DESC=	FastCGI support (for CGI binary)

.include <bsd.port.options.mk>
PORT_OPTIONS+=	FIBERS PROFILER SOCKET PROCESS FS ZLIB BINARY_B

USE_ICONV=	yes
USE_SCONS=	yes
WRKSRC=		${WRKDIR}/${DISTNAME}/${PORTNAME}

LIB_DEPENDS=	v8:${PORTSDIR}/lang/v8 \
		execinfo:${PORTSDIR}/devel/libexecinfo

SCONS_ARGS=	v8_path=${LOCALBASE}/include \
		config_file=${PREFIX}/etc/teajs.conf

.if ${PORT_OPTIONS:MFIBERS}
SCONS_ARGS+=	fibers=1
PLIST_SUB+=	FIBERS=""
.else
SCONS_ARGS+=	fibers=0
PLIST_SUB+=	FIBERS="@comment "
.endif

.if ${PORT_OPTIONS:MMYSQL}
USE_MYSQL=	yes
SCONS_ARGS+=	mysql=1 \
		mysql_path=${LOCALBASE}/include/mysql \
		libpath=${LOCALBASE}/lib/mysql
PLIST_SUB+=	MYSQL=""
.else
SCONS_ARGS+=	mysql=0
PLIST_SUB+=	MYSQL="@comment "
.endif

.if ${PORT_OPTIONS:MMEMCACHED}
LIBDEPENDS+=	memcached:${PORTSDIR}/databases/libmemcached
SCONS_ARGS+=	memcached=1
PLIST_SUB+=	MEMCACHED=""
.else
SCONS_ARGS+=	memcached=0
PLIST_SUB+=	MEMCACHED="@comment "
.endif

.if ${PORT_OPTIONS:MPROFILER}
SCONS_ARGS+=	profiler=1
PLIST_SUB+=	PROFILER=""
.else
SCONS_ARGS+=	profiler=0
PLIST_SUB+=	PROFILER="@comment "
.endif

.if ${PORT_OPTIONS:MPGSQL}
USE_PGSQL=	yes
SCONS_ARGS+=	pgsql=1 \
		pgsql_path=${LOCALBASE}/include/postgresql/server
PLIST_SUB+=	PGSQL=""
.else
SCONS_ARGS+=	pgsql=0
PLIST_SUB+=	PGSQL="@comment "
.endif

.if ${PORT_OPTIONS:MSQLITE}
USE_SQLITE=	3
SCONS_ARGS+=	sqlite=1
PLIST_SUB+=	SQLITE=""
.else
SCONS_ARGS+=	sqlite=0
PLIST_SUB+=	SQLITE="@comment "
.endif

.if ${PORT_OPTIONS:MGD}
LIBDEPENDS+=	gd:${PORTSDIR}/graphics/gd
SCONS_ARGS+=	gd=1
PLIST_SUB+=	GD=""
.else
SCONS_ARGS+=	gd=0
PLIST_SUB+=	GD="@comment "
.endif

.if ${PORT_OPTIONS:MSOCKET}
SCONS_ARGS+=	socket=1
PLIST_SUB+=	SOCKET=""
.else
SCONS_ARGS+=	socket=0
PLIST_SUB+=	SOCKET="@comment "
.endif

.if ${PORT_OPTIONS:MPROCESS}
SCONS_ARGS+=	process=1
PLIST_SUB+=	PROCESS=""
.else
SCONS_ARGS+=	process=0
PLIST_SUB+=	PROCESS="@comment "
.endif

.if ${PORT_OPTIONS:MFS}
SCONS_ARGS+=	fs=1
PLIST_SUB+=	FS=""
.else
SCONS_ARGS+=	fs=0
PLIST_SUB+=	FS="@comment "
.endif

.if ${PORT_OPTIONS:MZLIB}
SCONS_ARGS+=	zlib=1
PLIST_SUB+=	ZLIB=""
.else
SCONS_ARGS+=	zlib=0
PLIST_SUB+=	ZLIB="@comment "
.endif

.if ${PORT_OPTIONS:MTLS}
SCONS_ARGS+=	tls=1
PLIST_SUB+=	TLS=""
.else
SCONS_ARGS+=	tls=0
PLIST_SUB+=	TLS="@comment "
.endif

.if ${PORT_OPTIONS:MXDOM}
LIBDEPENDS+=	xerces-c:${PORTSDIR}/textproc/xerces-c3
SCONS_ARGS+=	xdom=1 \
		xercesc_include=${LOCALBASE}/include/xercesc
PLIST_SUB+=	XDOM=""
.else
SCONS_ARGS+=	xdom=0
PLIST_SUB+=	XDOM="@comment "
.endif

.if ${PORT_OPTIONS:MGL}
USE_GL=		glut glu glew
SCONS_ARGS+=	gl=1 \
		gl_include=${LOCALBASE}/include/GL
PLIST_SUB+=	GL=""
.else
SCONS_ARGS+=	gl=0
PLIST_SUB+=	GL="@comment "
.endif

.if ${PORT_OPTIONS:MBINARY_B}
SCONS_ARGS+=	binary_b=1
PLIST_SUB+=	BINARY_B=""
.else
SCONS_ARGS+=	binary_b=0
PLIST_SUB+=	BINARY_B="@comment "
.endif

.if ${PORT_OPTIONS:MMODULE}
USE_APACHE=	22+
LIB_DEPENDS+=	apr-1:${PORTSDIR}/devel/apr1
SCONS_ARGS+=	module=1 \
		apr_path=${LOCALBASE}/include/apr-1 \
		apache_path=${LOCALBASE}/${APACHEINCLUDEDIR}
PLIST_SUB+=	MODULE=""
.else
SCONS_ARGS+=	module=0
PLIST_SUB+=	MODULE="@comment "
.endif

.if ${PORT_OPTIONS:MCGI}
SCONS_ARGS+=	cgi=1
PLIST_SUB+=	CGI=""
.else
SCONS_ARGS+=	cgi=0
PLIST_SUB+=	CGI="@comment "
.endif

.if ${PORT_OPTIONS:MFCGI}
LIB_DEPENDS+=	fcgi:${PORTSDIR}/www/fcgi
SCONS_ARGS+=	fcgi=1
PLIST_SUB+=	FCGI=""
.else
SCONS_ARGS+=	fcgi=0
PLIST_SUB+=	FCGI="@comment "
.endif

post-configure:
	${SED} -e 's|%%PREFIX%%|${PREFIX}|' ${INSTALL_WRKSRC}/teajs.conf.posix > ${INSTALL_WRKSRC}/teajs.conf.dist

do-install:
.if ${PORT_OPTIONS:MCGI}
	${INSTALL_PROGRAM} ${INSTALL_WRKSRC}/tea ${PREFIX}/bin/
.endif
	${INSTALL_DATA} ${INSTALL_WRKSRC}/teajs.conf.dist ${PREFIX}/etc/
	if [ ! -f ${PREFIX}/etc/teajs.conf ]; then \
		${CP} -p ${PREFIX}/etc/teajs.conf.dist ${PREFIX}/etc/teajs.conf; \
	fi
	${MKDIR} ${PREFIX}/lib/teajs
	${INSTALL_LIB} ${INSTALL_WRKSRC}/lib/*.so ${PREFIX}/lib/teajs/
	${INSTALL_DATA} ${INSTALL_WRKSRC}/lib/*.js ${PREFIX}/lib/teajs/
.if ${PORT_OPTIONS:MMODULE}
	${APXS} -i -a -n teajs ${INSTALL_WRKSRC}/mod_teajs.so
	${INSTALL_DATA} ${INSTALL_WRKSRC}/apache2/mods-available/teajs.conf ${PREFIX}/${APACHEETCDIR}/Includes/
.endif
.include <bsd.port.mk>
