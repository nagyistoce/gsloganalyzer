#
# GNUmakefile 
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

PACKAGE_NAME = TKLogAnalyzer
include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = TKDummyLogSink
BUNDLE_EXTENSION = .logsink

OBJCFLAGS += -Wall

#
# We are creating a bundle
#
TKDummyLogSink_OBJC_FILES = TKDummyLogSink.m
TKDummyLogSink_PRINCIPAL_CLASS = TKDummyLogSink

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.local
-include GNUmakefile.postamble