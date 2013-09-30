/* -*- Mode: ObjC -*-

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Kack,,,,

   Created: 2010-11-24 22:21:35 +0100 by timkack

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

#import "TKAccessLine.h"
#import "GNUstepBase/GNUstep.h"
#import <regex.h>

/**

Design changes introduced with the new OrderedCollection design.

Consider a log line like this:
"item1 item2 item3"

The field extraction would work the following way:
(collect 'item1')(skip space)(collect 'item2')(skip space)(collect 'item3')
If the log line changes to look like this:
"item1 specialitem item2 item3"
We cannot use the parser from the current class since it will parse "specialitem" as "item2"
This means that a specialize subclass needs to reimplement the whole parser to extract the fields.
How can this be corrected?

One way would be to have a dispatch table where the subclass can insert its parsing part between
item1 and item2 (in above example).
Example:

Class A

ParserDispatchTable (PDT):

| Index | Identifier (NSString *) | Dispatch (NSValue valueWithPointer:@selector(bla:))
+-------+-------------------------|----------------------------------------------------
|     0 | ITEM1                   | item1
|     1 | ITEM2                   | item2
|     2 | ITEM3                   | item3

If an analythic function asks for 'item2' would -item2 start at index 0
and first call -item1 in order to get to the right position to deliver value for 'item2'.

Lets say that A is subclassed in order to handle 'specialitem' as Class B.

Class B will first ask its super class to populate the ParserDispatchTable, then it will 
insert its -specialItem function at Index 2, i.e.

-(id)init
{
  self = [super init]; // This will establish the Class A PDT
  if (self != nil) 
  {
  // Now lets insert our special function that will add the entry to the PDT
    [self insertParserFunction: [NSValue valueWithPointer:@selector(specialItem:)] 
                         after: @"ITEM1"
	        withIdentifier: @"SPEC"
			 ];
  // If we wanted to prepend it to the PDT, we would use -insertParserFunction:before:withIdentifier instead
  }
}

If the inserted function is supposed to be public and parsed via a rules parser it needs
to be inserted into the componentCallbacks and componentsDescriptions as well.

The assumption on for each field parser is that it parses upto the end of the field.
No adjustments are made to align to the next field. This means that any skipping needs to be done
in the beginning of field (prelude).

*/


@implementation TKAccessLine

/**

   Methods to conform to the LogEntryProvider protocol

 */

+(NSDictionary *)componentDescriptions
{
  return [NSDictionary dictionaryWithObjectsAndKeys: 
		       @"Requesting ip address", @"IP", 
		       @"Request timestamp",@"DATETIME",
		       @"Response size excluding request data ",@"RSIZE",
		       @"Session id cookie associated with request",@"SESSIONID",
		       @"HTTP Status code",@"STATUS",
		       @"Time to process the request in seconds",@"TIMEINS", 
		       @"Time to process the request in milliseconds",@"TIMEINMS",
		       @"Request URI",@"URI",
		       @"Useragent used for the request",@"USERAGENT",
		       @"User id associated with the request",@"USERID",
		       nil];
}

+(NSDictionary *)componentCallbacks 
{
  // Selector | Mnemonic
  return [NSDictionary dictionaryWithObjectsAndKeys: 
		  [NSValue valueWithPointer:@selector(ip)],@"IP", 
		[NSValue valueWithPointer:@selector(date)],@"DATETIME",
			  [NSValue valueWithPointer:@selector(requestSize)],@"RSIZE",
	   [NSValue valueWithPointer:@selector(sessionId)],@"SESSIONID",
	      [NSValue valueWithPointer:@selector(status)],@"STATUS",
		       [NSValue valueWithPointer:@selector(timeInMilliSeconds)],@"TIMEINMS", 
		       [NSValue valueWithPointer:@selector(timeInSeconds)],@"TIMEINS",
			  [NSValue valueWithPointer:@selector(uri)],@"URI",
	   [NSValue valueWithPointer:@selector(userAgent)],@"USERAGENT",
	      [NSValue valueWithPointer:@selector(userId)],@"USERID",nil];
}

-(void)setScanLocation:(NSUInteger)aLocation;
{
  [lineScanner setScanLocation: aLocation];
}

-(NSUInteger)currentScanLocation
{
  return [lineScanner scanLocation];
}

// Possibly rename this function
-(void)registerFunctions:(id)aParserFactory
{
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(ip)] 
				 after: nil
			withIdentifier: @"IP"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(userId)]
				 after: @"IP"
			withIdentifier: @"USERID"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(datetime)]
				 after: @"USERID"
			withIdentifier: @"DATETIME"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(uri)]
				 after: @"DATETIME"
			withIdentifier: @"URI"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(status)]
				 after: @"URI"
			withIdentifier: @"STATUS"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(requestSize)]
				 after: @"STATUS"
			withIdentifier: @"RSIZE"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(userAgent)]
				 after: @"RSIZE"
			withIdentifier: @"USERAGENT"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(sessionId)]
				 after: @"USERAGENT"
			withIdentifier: @"SESSIONID"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(timeInSeconds)]
				 after: @"SESSIONID"
			withIdentifier: @"TIMEINS"];
  [aParserFactory insertParserFunction: [NSValue valueWithPointer:@selector(timeInMilliSeconds)]
				 after: @"TIMEINS"
			withIdentifier: @"TIMEINMS"];

}


-(id)initWithString:(NSString *)aLogLine
{

  self = [self init];
  if (self != nil) 
    {
      ASSIGNCOPY(aLine,aLogLine);
      lineScanner = [[NSScanner alloc] initWithString: aLine];
    }
  return self;
}


+(BOOL)canHandleLogType:(NSString *)aLogTypeIdentifier
{
  BOOL found = NO;
  NSString *iterObj;
  NSEnumerator *iter = [[self logTypes] objectEnumerator];
  while ((iterObj = [iter nextObject]) && !found)
    {
      found = [iterObj isEqualToString: aLogTypeIdentifier];
    }
  return found;
}
/**
   
   This should only be called if the NSBundle infoDictionary does not contain the
   LOGTYPES key.

 */

+(NSArray *)logTypes
{
  return [NSArray arrayWithObjects: @"text/x-vnd-bb-apache-log", nil];
}


/*
            ... end of protocol conforming
 */


// Class side debugging


+(NSString *)description
{
  NSString *tempStr;
  tempStr = [NSString stringWithFormat:
			@"%@\ncomponentDescriptions:%@",
		      [super description], [self componentDescriptions]];
  return tempStr; 

}

/*
 *  Initialize-release
 */

-(id)init 
{
  self = [super init];
  return self;
}

-(void)dealloc
{
  [super dealloc];
}

/*
 *   Accessors - Getters
 */

-(NSString *)userId 
{
  NSString *val;
  NSCharacterSet *skiptoset = [NSCharacterSet characterSetWithCharactersInString: @"_"];

  if (reqUID == nil) 
    {
      [lineScanner scanUpToCharactersFromSet:skiptoset intoString:NULL]; // Assume first underscore is a cool place
      [lineScanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString: &val];
      [self setUserId: val];
    } 
  return AUTORELEASE(reqUID);
}

-(NSNumber *)requestSize
{
  return [NSNumber numberWithUnsignedInteger: reqSize];
}

-(NSNumber *)status 
{

  return [NSNumber numberWithUnsignedInteger: reqStatus];
}

-(NSString *)ip
{
  NSString *val;
  NSCharacterSet *skiptoset = [NSCharacterSet characterSetWithCharactersInString: @"0123456789"];

  if (reqIP == nil) 
    {
      // Assume first digit is a cool place to start
      [lineScanner scanUpToCharactersFromSet:skiptoset intoString:NULL]; 
      [lineScanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString: &val];
      [self setIP: val];
    } 
  return AUTORELEASE(reqIP);
}

-(NSString *)sessionId 
{
  return AUTORELEASE(reqSId);
}

-(NSString *)uri
{
  // This should possibly return a NSURL instead
  NSString *val;
  NSCharacterSet *skiptoset = [NSCharacterSet alphanumericCharacterSet]; 
 
  if (reqUri == nil) 
    {
      // Assume first digit is a cool place to start
      [lineScanner scanUpToCharactersFromSet:skiptoset intoString:NULL]; 
      [lineScanner scanUpToString: @"\"" intoString: &val];
      [self setUri: val];
    } 
  return AUTORELEASE(reqUri);
}

-(NSString *)userAgent
{
  return AUTORELEASE(reqUA);
}

-(NSCalendarDate *)datetime
{
  /** 
     -date is a bit special, it calls its setter which in turn expects a string in ISO standard
     i,e YYYY-MM-DD HH:MM:SS +/-HHHMM
     -time is a companion method that does return the time portion of the date.
     TODO: The date handling needs to be internationalized as well as configured for different 
           date format strings. Current implementation just support dd/MMM/yyyy
	   A special handling might need to be done for OSX incase NSCalendarDate will be deprecated
	   before NSDate, NSCalendar and NSDateFormatter catches up in GNUstep
  */
  NSString *val;
  NSCharacterSet *skiptoset = [NSCharacterSet characterSetWithCharactersInString: @"01"]; 
 
  if (reqDate == nil) 
    {
      // Assume first digit is a cool place to start
      [lineScanner scanUpToCharactersFromSet:skiptoset intoString:NULL]; 
      [lineScanner scanUpToString: @"]" intoString: &val];
      [self setDateTime: val];
    } 
  return AUTORELEASE(reqDate); 
}

-(NSNumber *)timeInSeconds
{
  return [NSNumber numberWithFloat: reqTiS];
}

-(NSNumber *)timeInMilliSeconds
{
  return [NSNumber numberWithFloat: reqTiMS];
}

-(NSString *)uriStem 
{
  return AUTORELEASE(@"Stubbed");
}

-(NSDictionary *)uriParameters
{
  // TODO: Stubbed
  return [NSDictionary dictionaryWithObjectsAndKeys: @"StubValue", @"StubKey",nil];
}

-(NSDictionary *)components 
{
  // TODO: Should this be using raw values instead to avoid the message send?
  // The problem is that this class depends too much on the knowledge of the LogEntry interface
  // and should really just need to know the necessery (i.e. implement the LoEntryProvider protocol)

  return [NSDictionary dictionaryWithObjectsAndKeys: 
			 [self ip], @"IP", 
		       [self datetime], @"DATETIME",
		       [self requestSize], @"RSIZE",
		       [self sessionId], @"SESSIONID",
		       [self status], @"STATUS",
		       [self timeInMilliSeconds], @"TIMEINMS", 
		       [self timeInSeconds], @"TIMEINS",
		       [self uri], @"URI",
		       [self userAgent], @"USERAGENT",
		       [self userId], @"USERID",nil];
}


/*
 *   Accessors - Setters
 *
 * (This is the correct place to put formatters and validators if needed)
 *
 */

-(void)setIP: (NSString *)aString
{
  ASSIGN(reqIP, aString);
}

-(void)setUserId: (NSString *)aString 
{
  ASSIGN(reqUID, aString);
}

-(void)setDateTime: (NSString *)aString 
{
  // TODO: Fix for current OSX api as soon as NSCalendar and friends are done
 
  NSCalendarDate *aDate = [NSCalendarDate dateWithString: aString calendarFormat: @"%d/%b/%Y:%H:%M:%S %z"]; 
  if (aDate) 
    {
      ASSIGN(reqDate,aDate);
    }
}

-(void)setUri: (NSString *)aString
{
  NSString *method;
  NSRange t;
 
  NSScanner *ps;
  BOOL endOfParams = NO;

  // Extract request method
  t = [aString rangeOfString: @" "];
  method = [aString substringToIndex: t.location];

  // Check for parameters
  t = [aString rangeOfString: @"?"];
  if ( t.location > 0 ) 
    {
      // There are parameters in this url ...
      id localPool = [[NSAutoreleasePool alloc] init]; // Need a local pool since we will create tons of strings 
      NSString *separator;
      NSCharacterSet *paramSet = [NSCharacterSet characterSetWithCharactersInString: @"& "]; 
      NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity: 15];
      NSString *k;
      NSString *v;

      ps = [NSScanner scannerWithString: aString];
      [ps setScanLocation: t.location + 1 ];
      while ( ![separator isEqualToString: @" "] && [ps isAtEnd] == NO)
	{
	  [ps scanUpToString:@"=" intoString: &k]; 
	  [ps setScanLocation: [ps scanLocation] + 1]; // Skip the = sign
	  [ps scanUpToCharactersFromSet: paramSet intoString: &v];
	  if ([v rangeOfString: @"\%"].location > 0) 
	    {
	      // Check for % signs incase there are URL encoded stuff
	      v = [v stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	    }
	  [parameters setObject: [v copy] forKey: k];
	  separator = [NSString stringWithFormat:@"%C",[aString characterAtIndex: [ps scanLocation]]];
	  [ps setScanLocation: [ps scanLocation] + 1]; // Skip the & sign
	}
      ASSIGNCOPY(reqUriParams, parameters);
      [localPool release];
    }
  ASSIGN(reqUri,aString);
}


/**
   Debugging  - info related methods
 */

-(NSString *)description
{
  NSString	*tmpDesc;
  tmpDesc = [NSString stringWithFormat:
			@"%@\n"
		      "\n==== BBACCESSLINE: OBJECT PROPERTIES ====\n"
			    "       IP:(%@)\n"
			    " DATETIME:(%@)\n"
			    "   STATUS:(%i)\n"
			    "      URL:(%@)\n"
		            "URIPARAMS:(%@)\n"
			    "USERAGENT:(%@)\n"
			    "   USERID:(%@)\n"
		            "SESSIONID:(%@)\n"
			    "RTIME(ms):(%i)\n"
			    " RTIME(s):(%f)\n"
			    "     SIZE:(%i)\n",
		      [super description], 
		      reqIP,
		      reqDate,
		      reqStatus,
		      reqUri,
		      reqUriParams,
		      reqUA,
		      reqUID,
		      reqSId,
		      reqTiMS,
		      reqTiS,
		      reqSize
	     ];
  return tmpDesc;
}



@end



