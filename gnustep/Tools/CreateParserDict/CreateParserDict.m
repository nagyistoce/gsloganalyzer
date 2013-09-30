/* -*-ObjC-*-
   Project: CreateParserDict

   Copyright (C) 2011 Free Software Foundation

   Author: Tim Kack

   Created: 2011-01-06 16:09:34 +0100 by tkack

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

#import <Foundation/Foundation.h>
#import "GNUstepBase/GNUstep.h"
#import <libTKLogAnalyzer/TKLogParserRegistry.h>

/**

   !!!! Please note that this file is like a workspace in Smalltalk, lots and lots of test code !!!!

 */

NSDictionary *parserCreator(
			    NSString *eParser, 
			    NSString *logType, 
			    NSString *eLogType,
			    id requires,
			    id optional,
			    NSString *desc
			    ) 
{

  NSDictionary *aDict = [NSDictionary dictionaryWithObjectsAndKeys:
					eParser, @"extends",
				      logType, @"logtype",
				      eLogType, @"extendslogtype",
				      requires, @"requires",
				      optional, @"optional",
				      desc, @"description",nil];
  return [aDict retain];
					
}


int
main (void)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

  /* Create a bunch of general parsers and some normal ones.
     
     Fictive general parsers:

     TimestampParser
     TimestampParserWithTZ
     BracketRemoverParser
     DEHTMLizeParser
     XMLToPLISTParser

     Fictive normal parsers

     AccessLogParser
     SpecialAccessLogParser
     StdoutParser
     SpecialStdoutParser

   A ParserDefinition is this:

   ParserName {
       extends = <null or a parser that it either specializes or replaces>
       logtype = <null or logtype id that the parser understands>
       extendslogtype = <null or the logtype that it extends>
       requires = <null or a comma separated list  of (general/normal) parsers that it needs>
       optional = <null or a comma separated list of parser that it would like to have, but not necessery to do its job>
       description = <null or human readable what the parser does>
   }

   */

  // NSSet cannot be serialized

  //                              extends, logtype,extendslogtype,requires,optional,description
  NSDictionary *parsers = 
    [NSDictionary dictionaryWithObjectsAndKeys:
		    // Some general parsers
      parserCreator(@"", @"", @"", @"", @"", @"I am a TimestampParser"), @"TimestampParser",
      parserCreator(@"TimestampParser", @"", @"", @"", @"", @"I am a TimestampParser with timezones"), @"TimestampParserTZ",
      parserCreator(@"", @"", @"", @"", @"", @"I am a Bracket remover"), @"BracketRemoverParser",
      parserCreator(@"", @"", @"", @"", @"", @"I am a DEHTMLize parser"), @"DEHTMLizeParser",
      parserCreator(@"", @"", @"", @"", @"", @"I am a XMLToPLISTParser"), @"XMLToPLISTParser",
		  // Some normal parser - note that BluePrintParser does not exist.
      parserCreator(@"", @"text/access_log", @"", @"TimestampParserTZ", @"", @"I am a AccessLogParser"), @"AccessLogParser",
      parserCreator(@"", @"text/special-access_log", @"text/access_log", @"", @"DEHTMLizeParser,BracketRemoverParser", @"I am a SpecialAccessLogParser"), @"SpecialAccessLogParser",
      parserCreator(@"TimestampParserTZ", @"text/special-access_log2", @"text/special-access_log", @"", @"DEHTMLizeParser,BracketRemoverParser", @"I am a SpecialAccessLogParser2"), @"SpecialAccessLogParser2",
      parserCreator(@"", @"text/stdout-stderr", @"", @"XMLToPLISTParser,TimestampParserTZ", @"", @"I am a StdoutParser"), @"StdoutParser",
      parserCreator(@"", @"", @"text/stdout-stderr", @"", @"BluePrintParser,BracketRemoverParser", @"I am a SpecialStdoutParser"), @"SpecialStdoutParser", 
					nil];


  NSDictionary *parserDefaults = [NSDictionary dictionaryWithObjectsAndKeys: parsers, @"Parsers", nil];
  [defs setPersistentDomain:parserDefaults forName: @"TKLogAnalyzer"];
  [defs synchronize];
  
  TKLogParserRegistry *parserRegistry = [[TKLogParserRegistry alloc] init];
  //  NSDictionary *p = [parserRegistry parserForLogType: @"text/access_log"];
  //  NSDictionary *pn = [parserRegistry parserWithName: @"TimestampParser"];
  //  NSArray *pwithdep = [parserRegistry parserIncludingDependenciesForName: @"TimestampParserTZA"];
  NSArray *pTypeWithDep = [parserRegistry parserIncludingDependenciesForLogType: @"text/special-access_log2"];
  //  NSLog(@"Parser found: %@", p);
  //  NSLog(@"Parser (via name) found: %@", pn);
  // NSLog(@"Parser (via deps) found: %@", pwithdep);
  NSLog(@"Parser (via type deps) found: %@", pTypeWithDep);

  // TODO: Add LogSink code
  // Read back

  // Lets build some collections with parsers. 
  // Lets start with a simple one text/access_log

  /* 
     Discussion:

     If a Parser extends a LogType, will we need to find the BaseParser for that LogType and include it in the set
     If a Parser extends another Parser and a LogType will we first need to traverse the dependecy chain for 
     the extended parser until its root (i.e. the base parser for its logtype).
     If a Parser does not have a LogType is it considered to be a general Parser.
     Example:
   
    ApacheLogParser 
    {
      ExtendsParser = ""
      LogType = "text/access_log"
      Path = <applocal>
      ExtendsLogType = ""
    }

    ApacheTimestampParser 
    {
      ExtendsParser = HHMMTimestamp
      LogType = "text/access_log"
      Path = <applocal>
      ExtendsLogType = ""
    }

    is dependent on:

    HHMMTimestamp
    {
      ExtendsParser = HHMMTimestamp
      LogType = ""
      Path = <applocal>
      ExtendsLogType = ""
    }

    This means that the ApacheTimeStamp parser will specialize whatever fields ApacheLogParser parses out
    _using_ the general HHMMTimestamp parser.

    
    <LogSink>  <- ApacheLogParser <- ApacheTimestampParser
                                        |
                  HHMMTimestamp <-------+

    More specialized examples:

    SpecialApacheLogParser 
    {
      ExtendsParser = ""
      LogType = "text/special-access_log"
      Path = <applocal>
      ExtendsLogType = "text/access_log"
    }

    SpecialApacheTimestampParser 
    {
      ExtendsParser = HHMMTimestamp
      LogType = "text/special-access_log"
      Path = <applocal>
      ExtendsLogType = "text/access_log"
    }

    This parser extends the general HHMMTimestamp parser but also needs the base parser for the LogType text/access_log
    (ApacheLogParser). 
    
    <LogSink>  <- ApacheLogParser <- SpecialApacheLogParser <- SpecialApacheTimestampParser
                                                                          |
                                                    HHMMTimestamp <-------+

						   
   This whole mechanism should perhaps be broken down into filters:

   <Log Sink> <- ApacheLogParser <- SpecialApacheLogParser <- SpecialApacheTimestampParser
                                               |                      |
					       |                      +----> HHMMParser
                                               +---> BracketRemover


   A parser that depends on a general parser (such as HHMMParser) had a dependency to that.

   */
  [parserRegistry release];
  [pool drain];
  return 0;
}
