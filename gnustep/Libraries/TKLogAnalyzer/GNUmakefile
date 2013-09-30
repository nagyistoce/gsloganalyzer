#
# GNUmakefile
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# LogAnalyzer Library
#

LIBRARY_NAME = libTKLogAnalyzer

#
# Header files
#

libTKLogAnalyzer_HEADER_FILES = \
TKLogAnalyzer.h \
TKLogParserRegistry.h \
TKLogEntryProvider.h \
OrderedDictionary.h \
TKLogEntryParser.h \
TKLogEntryParserFactory.h \
TKLogSource.h

# TODO: This does not work on  mingw. Bug Report and fix
# libTKLogAnalyzer_HEADER_FILES_INSTALL_DIR = TKLogAnalyzer 

#
# Classes
# 

libTKLogAnalyzer_OBJC_FILES = \
TKLogParserRegistry.m \
TKLogAnalyzer.m \
OrderedDictionary.m \
TKLogEntryParser.m \
TKLogEntryParserFactory.m


#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/library.make
-include GNUmakefile.postamble
