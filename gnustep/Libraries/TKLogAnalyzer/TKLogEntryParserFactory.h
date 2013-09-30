/* -*- Mode: ObjC -*-

   Copyright (C) 2011 Free Software Foundation

   Author: tkack

   Created: 2011-01-17 10:35:20 +0100 by tkack

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

#ifndef _TKLOGENTRYPARSERFACTORY_H_
#define _TKLOGENTRYPARSERFACTORY_H_

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

/**

   The LogEntryParserFactory is responsible for creating instances of different type of log entries.
   It builds and configures LogEntryParsers.

   Example:

   aParser = [LogEntryParserFactory logEntryParserFor: @"text/x-vnd-apache-log"];
   [aParser setLogSource: aLogSink]; // aFileSink is a class that conforms to LogSource protocol.
   [aParser setKVParser: [ApacheLogLine class]];
   [aParser parse];
   
   The object can now be queried for the components.
   
   The factory will iterate over all known NSBundles and populate the LogEntry with classes that
   1) conform to the LogEntryProvider protocol
   2) Matches the logType
 
   The problem with above is that a specialization (i.e. when there is no 1:1 correlation 
   between log type and parser) cannot inject itself or replace a function.
   A solution to this can be a dependency scheme. Consider the following two scenarios: 
   
   Scenario 1:
   AccessLogLine is the base parser for "text/x-vnd-apache-log" log types.
   SpecialAccessLogLine is a specialized parser to parse USERAGENT. 
   While the base parser parses general data, does the SpecialAccessLogLine parser 
   extract information such as COOKIES, USERAGENTLANGUAGE etc.
   SpecialAccessLogLine *depends* on AccessLogLine and *replaces* the USERAGENT parsing.
   This means that SpecialAccessLogLine class needs to know about what pieces the base parser parses.

   Scenario 2:
   AccessLogLine can parse out values from "text/x-vnd-apache-log" logtypes, 
   but now there is a specialization of 
   the log adding an extra field, "text/x-vnd-bb-apache-log". SpecialAccessLogLine is created 
   to handle that extra field.
   In order to handle that will the SpecialAccessLogLine parser requires a 
   parser that can handle "text/x-vnd-apache-log" and does not depend on 
   on another base parser. This means that "text/x-vnd-bb-apache-log" is a 
   specialization of "text/x-vnd-apache-log" and SpecialAccessLogLine is an 
   *extension* to BbAccessLine.

   In both scenarios do I need to create facilities to answer 
   dependsOnLogTypeParser:onlyBase: and extendsLogType:
   I believe the best way of doing this is to use Defaults. 

   Parser lookup mechanism
   =======================

   This describes the lookup mechanism when the log type is known, i.e. when a logType: is specified.
   1) Create an LogEntryParserFactory instance for a type: 
       aFactory = [[LogEntryParserFactory alloc] initForType: @"text/x-vnd-bb-access-log"];
   2) initForType: will ask the standardUserDefaults for the logType dictionary:
       defaults = [NSUserDefaults standardUserDefaults]; 
       logtypes = [NSDictionary dictionaryWithDicationary: 
                 [defaults dictionaryForKey: @"GSLogAnalyzerLogTypes"]];
   3) Each log type has a dictionary as a value with the following keys:
       EXTENDSTYPE - If the parser extends or replaces a parser will 
                the value for the key contain the logtype it extends
       VERSION - This is merely for upgrading bundles 
       BUNDLENAME - The filename of the bundle

 */

@interface TKLogEntryParserFactory : NSObject
{
  /**
     The logEntryParsers is a collections LogEntryParser instances.
   */
	NSMutableArray *logEntryParsers; 
	NSDictionary *knownParsers;
	OrderedDictionary *pdt;
	BOOL parsedFlag;
}

// Code needed for getting bundles since we expect to have external NSBundle type of LogEntryProviders

// Initialize-Release

-(id)init;
-(id)initWithString:(NSString *)aLine;
-(void)dealloc;

// Configuration 

-(void)insertParserFunction:(NSValue *)aFunctionPtr 
		      after: (NSString *)aKey 
	     withIdentifier: (NSString *)ident;

-(void)insertParserFunction:(NSValue *)aFunctionPtr 
		     before: (NSString *)aKey 
	     withIdentifier: (NSString *)ident;
// Accessors

// Actions

-(void)parse;

// Testing
-(BOOL)isParsed;

-(NSString *)description;



@end

#endif // _TKLOGENTRYPARSERFACTORY_H_

