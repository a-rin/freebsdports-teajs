--- ./src/mod_teajs.cc.orig	2012-07-20 15:40:07.000000000 +0900
+++ ./src/mod_teajs.cc	2013-02-02 15:20:21.704985378 +0900
@@ -55,6 +55,10 @@
 	void execute(request_rec * request, char ** envp) {
 		this->request = request;
 		this->mainfile = std::string(request->filename);
+		if (! path_file_exists(this->mainfile)) {
+			this->exit_code = 404;
+			return;
+		}
 		int chdir_result = path_chdir(path_dirname(this->mainfile));
 		if (chdir_result == -1) { return; }
 		TeaJS_App::execute(envp);
