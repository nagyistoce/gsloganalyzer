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


SUBPROJECTS = \
  TKAccessLogParser \
  BBAccessLogParser

-include GNUmakefile.preamble
-include GNUmakefile.local
include $(GNUSTEP_MAKEFILES)/aggregate.make
-include GNUmakefile.postamble
