#
# GNUmakefile 
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif


PACKAGE_NAME = loganalyzer
include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = BBAccessLog
BUNDLE_EXTENSION = .parser

OBJCFLAGS += -Wall

#
# We are creating a bundle
#
BBAccessLog_OBJC_FILES = BBAccessLine.m

BBAccessLog_PRINCIPAL_CLASS = BBAccessLine

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.local
-include GNUmakefile.postamble