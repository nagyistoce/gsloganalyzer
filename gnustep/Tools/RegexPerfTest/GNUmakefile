#
# GNUmakefile 
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

TOOL_NAME = RegexPerfTest RegexPerfTestMemory RegexPerfTestMemory-Ogre
include $(GNUSTEP_MAKEFILES)/common.make

OBJCFLAGS += -Wall

#ADDITIONAL_OBJC_LIBS = -lTKLogAnalyzer
#
# We are creating a tool
#

RegexPerfTest_OBJC_FILES = RegexPerfTest.m
RegexPerfTestMemory_OBJC_FILES = RegexPerfTestMemory.m
RegexPerfTestMemory-Ogre_OBJC_FILES = RegexPerfTestMemory-Ogre.m


ADDITIONAL_NATIVE_LIBS = OgreKit
include $(GNUSTEP_MAKEFILES)/tool.make

-include GNUmakefile.preamble
-include GNUmakefile.local
-include GNUmakefile.postamble
