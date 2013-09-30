/* -*-ObjC-*-
   Project: LogAnalyzer

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

#import "TKLogAnalyzer.h"
#import "GNUstepBase/GNUstep.h"
#import "TKLogParserRegistry.h"

@implementation TKLogAnalyzer

  static TKLogAnalyzer *singleInstance = nil;

+(id)sharedInstance 
{
  if (!singleInstance)
    {
      singleInstance = [[[self class] alloc] init];
    }
  return singleInstance;
}

- (id)init 
{

  if ( singleInstance != nil) {
    [NSException raise:NSInternalInconsistencyException
		format:@"[%@ %@] is an invalid call; use +[%@ %@] instead]",
		 NSStringFromClass([self class]), NSStringFromSelector(_cmd),
		 NSStringFromClass([self class]), NSStringFromSelector(@selector(sharedInstance))];
  } 
  else 
    if ( (self = [super init]) ) {
      singleInstance = self;
   
      factories = [[NSMutableArray alloc] init];

      parserRegistry = [[TKLogParserRegistry alloc] init];
      //      registeredLogSinks = [[NSMutableDictionary alloc] init];
      //      registeredLogCollectors = [[NSMutableDictionary alloc] init];

    }
  return singleInstance;
}

-(NSUInteger)retainCount
{
  return ULONG_MAX;
}

-(oneway void)release
{
  // This instance should never be released
}

-(id)retain
{
  return singleInstance;
}

-(id)autorelease
{
  return singleInstance;
}

-(void)registerParserWithName:(NSString *)parserName
		   setLogType:(NSString *)aLogTypeString
		     withPath:(NSString *)aPath
	extendsParserWithName:(NSString *)exParserNameOrEmpty
	       extendsLogType:(NSString *)exLogTypeStringOrEmpty
{
  // This needs to be done within the TKParserRegistry
}

-(void)unregisterParserWithName:(NSString *)parserName
{
  // This needs to be done within the TKParserRegistry
}


-(TKLogEntryParserFactory *)logEntryFactoryForLogType:(NSString *)logType
{
  TKLogEntryParserFactory *aFactory = [[TKLogEntryParserFactory alloc] init];

  return AUTORELEASE(aFactory);
}

@end
