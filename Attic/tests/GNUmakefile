include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = ParserUtilTester

Examples_HEADER_FILES = \
	LogEntityTest.h\
	ParserUtilsTests.h

Examples_OBJC_FILES = \
	LogEntityTest.m\
	ParserUtilsTests.m\
	main.m

Examples_TOOL_LIBS = -lObjcUnit

ADDITIONAL_OBJCFLAGS = -Wno-import -Wall

-include GNUmakefile.preamble
-include GNUmakefile.local
include $(GNUSTEP_MAKEFILES)/tool.make
-include GNUmakefile.postamble
