--- ./src/lib/binary-b/bytestorage-b.cc.orig	2012-07-20 15:40:07.000000000 +0900
+++ ./src/lib/binary-b/bytestorage-b.cc	2013-02-02 15:20:21.703986005 +0900
@@ -247,7 +247,7 @@
 	
 	size_t inBytesLeft = this->length;
 	size_t outBytesLeft = allocated;
-	ICONV_INPUT_T inBuf = (ICONV_INPUT_T) this->data;
+	const ICONV_INPUT_T inBuf = (ICONV_INPUT_T) this->data;
 	char * outBuf = output;
 
 	size_t result = 0;
