# $FreeBSD$

PORTNAME=	teajs
PORTVERSION=	0.9.5dev
CATEGORIES=	www
#MASTER_SITES=	${MASTER_SITE_GOOGLE_CODE}
#DISTNAME=	${PORTNAME}-${PORTVERSION}-src
#WRKSRC=		${WRKDIR}/${DISTNAME}/${PORTNAME}

GH_ACCOUNT=	ondras
GH_PROJECT=	TeaJS
GH_TAGNAME=	master
GH_COMMIT=	28842302e851fa738c1616ace8bb790a34799fb9
MASTER_SITES=	http://github.com/${GH_ACCOUNT}/${GH_PROJECT}/archive/${GH_COMMIT}.tar.gz?dummy=/
DISTNAME=	${GH_PROJECT}-${GH_COMMIT}
FETCH_ARGS=	-Fpr

MODULENAME=	mod_teajs

MAINTAINER=	a.rin.mix@gmail
COMMENT=	Server-side Javascript language and libraries


OPTIONS_DEFINE=	MYSQL MEMCACHED PGSQL SQLITE GD TLS XDOM GL MODULE CGI
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

#USE_ICONV=	yes
#USE_SCONS=	yes
USES=		scons iconv

LIB_DEPENDS=	libv8.so:${PORTSDIR}/lang/v8 \
		libexecinfo.so:${PORTSDIR}/devel/libexecinfo

MAKE_ARGS+=	v8_path=${LOCALBASE}/include \
		config_file=${PREFIX}/etc/teajs.conf

.if ${PORT_OPTIONS:MFIBERS}
MAKE_ARGS+=	fibers=1
PLIST_SUB+=	FIBERS=""
.else
MAKE_ARGS+=	fibers=0
PLIST_SUB+=	FIBERS="@comment "
.endif

.if ${PORT_OPTIONS:MMYSQL}
USE_MYSQL=	yes
MAKE_ARGS+=	mysql=1 \
		mysql_path=${LOCALBASE}/include/mysql \
		libpath=${LOCALBASE}/lib/mysql
PLIST_SUB+=	MYSQL=""
.else
MAKE_ARGS+=	mysql=0
PLIST_SUB+=	MYSQL="@comment "
.endif

.if ${PORT_OPTIONS:MMEMCACHED}
LIB_DEPENDS+=	libmemcached.so:${PORTSDIR}/databases/libmemcached
MAKE_ARGS+=	memcached=1
PLIST_SUB+=	MEMCACHED=""
.else
MAKE_ARGS+=	memcached=0
PLIST_SUB+=	MEMCACHED="@comment "
.endif

.if ${PORT_OPTIONS:MPROFILER}
MAKE_ARGS+=	profiler=1
PLIST_SUB+=	PROFILER=""
.else
MAKE_ARGS+=	profiler=0
PLIST_SUB+=	PROFILER="@comment "
.endif

.if ${PORT_OPTIONS:MPGSQL}
USE_PGSQL=	yes
MAKE_ARGS+=	pgsql=1 \
		pgsql_path=${LOCALBASE}/include/postgresql/server
PLIST_SUB+=	PGSQL=""
.else
MAKE_ARGS+=	pgsql=0
PLIST_SUB+=	PGSQL="@comment "
.endif

.if ${PORT_OPTIONS:MSQLITE}
USE_SQLITE=	3
MAKE_ARGS+=	sqlite=1
PLIST_SUB+=	SQLITE=""
.else
MAKE_ARGS+=	sqlite=0
PLIST_SUB+=	SQLITE="@comment "
.endif

.if ${PORT_OPTIONS:MGD}
LIB_DEPENDS+=	libgd.so:${PORTSDIR}/graphics/gd
MAKE_ARGS+=	gd=1
PLIST_SUB+=	GD=""
.else
MAKE_ARGS+=	gd=0
PLIST_SUB+=	GD="@comment "
.endif

.if ${PORT_OPTIONS:MSOCKET}
MAKE_ARGS+=	socket=1
PLIST_SUB+=	SOCKET=""
.else
MAKE_ARGS+=	socket=0
PLIST_SUB+=	SOCKET="@comment "
.endif

.if ${PORT_OPTIONS:MPROCESS}
MAKE_ARGS+=	process=1
PLIST_SUB+=	PROCESS=""
.else
MAKE_ARGS+=	process=0
PLIST_SUB+=	PROCESS="@comment "
.endif

.if ${PORT_OPTIONS:MFS}
MAKE_ARGS+=	fs=1
PLIST_SUB+=	FS=""
.else
MAKE_ARGS+=	fs=0
PLIST_SUB+=	FS="@comment "
.endif

.if ${PORT_OPTIONS:MZLIB}
MAKE_ARGS+=	zlib=1
PLIST_SUB+=	ZLIB=""
.else
MAKE_ARGS+=	zlib=0
PLIST_SUB+=	ZLIB="@comment "
.endif

.if ${PORT_OPTIONS:MTLS}
MAKE_ARGS+=	tls=1
PLIST_SUB+=	TLS=""
.else
MAKE_ARGS+=	tls=0
PLIST_SUB+=	TLS="@comment "
.endif

.if ${PORT_OPTIONS:MXDOM}
LIB_DEPENDS+=	libxerces-c.so:${PORTSDIR}/textproc/xerces-c3
MAKE_ARGS+=	xdom=1 \
		xercesc_include=${LOCALBASE}/include/xercesc
PLIST_SUB+=	XDOM=""
.else
MAKE_ARGS+=	xdom=0
PLIST_SUB+=	XDOM="@comment "
.endif

.if ${PORT_OPTIONS:MGL}
USE_GL=		glut glu glew
MAKE_ARGS+=	gl=1 \
		gl_include=${LOCALBASE}/include/GL
PLIST_SUB+=	GL=""
.else
MAKE_ARGS+=	gl=0
PLIST_SUB+=	GL="@comment "
.endif

.if ${PORT_OPTIONS:MBINARY_B}
MAKE_ARGS+=	binary_b=1
PLIST_SUB+=	BINARY_B=""
.else
MAKE_ARGS+=	binary_b=0
PLIST_SUB+=	BINARY_B="@comment "
.endif

.if ${PORT_OPTIONS:MMODULE}
USE_APACHE=	22+
LIB_DEPENDS+=	libapr-1.so:${PORTSDIR}/devel/apr1
MAKE_ARGS+=	module=1 \
		apr_path=${LOCALBASE}/include/apr-1 \
		apache_path=${LOCALBASE}/${APACHEINCLUDEDIR}
PLIST_SUB+=	MODULE=""
.else
MAKE_ARGS+=	module=0
PLIST_SUB+=	MODULE="@comment "
.endif

.if ${PORT_OPTIONS:MCGI}
MAKE_ARGS+=	cgi=1
PLIST_SUB+=	CGI=""
.else
MAKE_ARGS+=	cgi=0
PLIST_SUB+=	CGI="@comment "
.endif

.if ${PORT_OPTIONS:MFCGI}
LIB_DEPENDS+=	libfcgi.so:${PORTSDIR}/www/fcgi
MAKE_ARGS+=	fcgi=1
PLIST_SUB+=	FCGI=""
.else
MAKE_ARGS+=	fcgi=0
PLIST_SUB+=	FCGI="@comment "
.endif

post-configure:
	${SED} -e 's|%%PREFIX%%|${PREFIX}|' ${INSTALL_WRKSRC}/teajs.conf.posix > ${INSTALL_WRKSRC}/teajs.conf.dist

do-install:
.if ${PORT_OPTIONS:MCGI}
	${INSTALL_PROGRAM} ${INSTALL_WRKSRC}/tea ${STAGEDIR}${PREFIX}/bin/
.endif
	${INSTALL_DATA} ${INSTALL_WRKSRC}/teajs.conf.dist ${STAGEDIR}${PREFIX}/etc/
	if [ ! -f ${STAGEDIR}${PREFIX}/etc/teajs.conf ]; then \
		${CP} -p ${STAGEDIR}${PREFIX}/etc/teajs.conf.dist ${STAGEDIR}${PREFIX}/etc/teajs.conf; \
	fi
	${MKDIR} ${STAGEDIR}${PREFIX}/lib/teajs
	${INSTALL_LIB} ${INSTALL_WRKSRC}/lib/*.so ${STAGEDIR}${PREFIX}/lib/teajs/
	${INSTALL_DATA} ${INSTALL_WRKSRC}/lib/*.js ${STAGEDIR}${PREFIX}/lib/teajs/
.if ${PORT_OPTIONS:MMODULE}
	@${MKDIR} ${STAGEDIR}${PREFIX}/${APACHEMODDIR}
	@${APXS}  -S LIBEXECDIR=${STAGEDIR}${PREFIX}/${APACHEMODDIR} -i -n teajs ${INSTALL_WRKSRC}/mod_teajs.so
	@${MKDIR} ${STAGEDIR}${PREFIX}/${APACHEETCDIR}/Includes/
	${INSTALL_DATA} ${INSTALL_WRKSRC}/apache2/mods-available/teajs.conf ${STAGEDIR}${PREFIX}/${APACHEETCDIR}/Includes/
.endif
.include <bsd.port.mk>
