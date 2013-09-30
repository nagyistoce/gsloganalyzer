/* -*-ObjC-*-
   Project: LogAnalyzer

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Kack,,,,

   Created: 2010-11-24 22:20:18 +0100 by timkack

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#ifndef _TKLOGANALYZER_H_
#define _TKLOGANALYZER_H_
#import <Foundation/Foundation.h>
#import "GNUstepBase/GNUstep.h"
#import "TKLogParserRegistry.h"
#import "TKLogEntryParserFactory.h"

/**
TKLogAnalyzer is a singleton class.
From this class can instances ofTKLogEntryParserFactory be created.
The TKLogEntryParserFactory produces TKLogEntryParser instances and configures these to use the TKLogSink chosen. 

The registeredLogParsers data structure looks like this:

Name = "Unique parser name"
ExtendsParser = "nil or the Name of the parser that it extends/replaces"
LogType = "Required logtype identifier"
ExtendsLogType = "nil or the LogType that this extends"
Path = "Path to the bundle"
 */

@interface TKLogAnalyzer : NSObject
{
  NSMutableArray *factories;
  TKLogParserRegistry *parserRegistry;
  NSMutableDictionary *registeredLogSinks;
  NSMutableDictionary *registeredLogCollectors;
}

// Singleton class
+(id)sharedInstance;

// Initialize-Release

-(id)init;

// Muted behavior
-(oneway void)release;
-(id)retain;
-(id)autorelease;

// Actions - Factories
-(TKLogEntryParserFactory *)logEntryFactoryForLogType:(NSString *)logType;

// Actions - parsers
/**
-registerParserWithName:setLogType:withPath:extendsParserWithName:extendsLogType: 
registers the parser in the standard user defaults for the NSGlobalDomain.
It needs to be set in the NSGlobalDomain since TKLogAnalyzer might be used in several applications.

 */
-(void)registerParserWithName:(NSString *)parserName
		   setLogType:(NSString *)aLogTypeString
		     withPath:(NSString *)aPath
	extendsParserWithName:(NSString *)exParserNameOrEmpty
	       extendsLogType:(NSString *)exLogTypeStringOrEmpty;

-(void)unregisterParserWithName:(NSString *)parserName;
  
// Accessors

@end
#endif // _TKLOGANALYZER_H_
