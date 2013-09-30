AC_PREREQ(2.59)
AC_INIT([GNU Smalltalk package XYZ], [0.0], , gst-xyz)
AC_CONFIG_SRCDIR([/Users/tkack/Sources/gsloganalyzer/smalltalk/Libraries/Logger/package.xml])

AM_INIT_AUTOMAKE

AM_PATH_GST([2.95c], , [AC_MSG_ERROR([GNU Smalltalk not found])])
GST_PACKAGE_ENABLE([Logger], [Logger])
GST_PACKAGE_ENABLE([LogAnalyzer-BaseLibs], [LogAnalyzer])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([gst], [chmod +x gst])
AC_OUTPUT
