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

BUNDLE_NAME = TKAccessLog
BUNDLE_EXTENSION = .parser

OBJCFLAGS += -Wall

#
# We are creating a bundle
#
TKAccessLog_OBJC_FILES = TKAccessLine.m

TKAccessLog_PRINCIPAL_CLASS = TKAccessLine

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.local
-include GNUmakefile.postamble