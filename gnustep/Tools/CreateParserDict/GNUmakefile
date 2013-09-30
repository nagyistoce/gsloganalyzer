#
# GNUmakefile 
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

TOOL_NAME = CreateParserDict
include $(GNUSTEP_MAKEFILES)/common.make

OBJCFLAGS += -Wall
ADDITIONAL_OBJC_LIBS = -lTKLogAnalyzer
#
# We are creating a tool
#

CreateParserDict_OBJC_FILES = CreateParserDict.m

include $(GNUSTEP_MAKEFILES)/tool.make

-include GNUmakefile.preamble
-include GNUmakefile.local
-include GNUmakefile.postamble