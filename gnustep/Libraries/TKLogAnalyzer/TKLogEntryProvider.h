/* -*- Mode: ObjC -*-

   Copyright (C) 2010 Free Software Foundation

   Author: tkack

   Created: 2010-12-15 12:51:55 +0100 by tkack

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

@protocol TKLogEntryProvider <NSObject>

/**
   +componentDescriptions; returns an NSDictionary with all known component keys and their descriptions.
*/ +(NSDictionary *)componentDescriptions;

/**
Any class that subclasses another LogEntryProvider needs to also add the componentCallbacks from its super class.
The callbacks table is used in by aggregate functions to be able to extract a field/value 
from a log file independed of what type of log it is. 
It allows for creating functions that uses the key in its parse tables.
Example:

BbAccessLine *aLine; // This is initialize somewhere else
NSString *criteria = @"STATUS != 500";
 ...some parsing of the criteria string ...
if ([aLine performSelector: [[BbAccessLine componentCallbacks] valueForKey: @"STATUS"]] != 500)
{
... perhaps add the URI to an array etc ...
}
 
A rule parser can be created this way and only depend on lookups in a table.
It does not need to know the the LogEntryProvider is implemented.
Note that the type is not passed on which means that the callback function needs to know what data type is being returned.
TODO: Possibly normalize the returned values into a standard data type (NSString etc) and create a conversion callback table to support specialized comparisions.

*/
+(NSDictionary *)componentCallbacks;

/**
The -currentScanLocation; method should report back at what point the scan position is.
Consider the following situation:

LogEntryParserFactory

AccessLog | SpecializedAccessLog
----------+---------------------
IP        |
          | USERID
DATETIME  | 
URI       |
STATUS    |
...

When the parser is calling the IP method from an instance of AccessLog class 
to extract the IP it stops scanning at position X.
Since USERID comes next to be scanned, it needs to know where to start scanning.
If that mechanism wouldn't be there, the scanner might have to trial an error a lot of similiar chunks of text.
Example:
    
     "10.2.3.4 222.12 "Some string" another value"

The first field is an IP address, the second might be server load. A server load field extractor might
get confused by the ip address.
There for will the LogEntryParserFactory ask the first parser for its currentScanLocation and set the 
second parser's scan location with -setScanLocation:

 */ -(NSUInteger)currentScanLocation;
-(void)setScanLocation:(NSUInteger)aLocation;

/**

-canHandleLogType: will be called by the LogEntryParserFactory with LogTypeIdentifier.
The identifier looks like a mime type, like  "text/x-vnd-apache-log".
It needs to return YES/true if the LogEntryProvider can handle the type.
Its companion method; logTypes should return a list of types that it can handle. 
 */

-(BOOL)canHandleLogType:(NSString *)aLogTypeIdentifier;
+(NSArray *)logTypes;

/**

-registerFunctions: will be called when the class is instantiated with a ParserFactory as argument.
This will allow the class to call insertParserFunction: [NSValue valueWithPointer:@selector(selector)] after:@"SOMEID" withIdentifier:@"MYID"]; to register it parsing functions at the correct places.
The parser factory can also be queried for its current known identifiers by asking it for -registeredFunctions. This will return a NSArray with all known fields in order.
 */ -(void)registerFunctions:(id)aParserFactory;

/**

-initWithString: is the designated initializer and is what the LogProvider will use to give data to the
LogEntryProvider.
 */

-(id)initWithString:(NSString *)aLogLine;


@end
