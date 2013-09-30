/* -*-ObjC-*-
   Project: LogAnalyzer

   Copyright (C) 2011 Free Software Foundation

   Author: Tim Kack

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

#import "TKLogEntryParserFactory.h"

@implementation TKLogEntryParserFactory

/*
  Initialize-release
*/

-(id)init 
{
  self = [super init];
  if (self != nil) 
	{
		parsedFlag = NO;
		pdt = [[OrderedDictionary alloc] init];
		
//      providerClasses = [[NSMutableArray alloc] init];
    }
  return self;
}

-(id)initWithString:(NSString *)aLine
{
  if (([self init])) 
    {
      [self parse];
    }
  return self;
}

-(void)dealloc 
{
//  DESTROY(pdt);
  [super dealloc];
}

-(void)parse 
{
  id methodId, dummy;
  SEL funct;
  NSEnumerator *iter = [pdt keyEnumerator];

  if ( parsedFlag == NO ) {

    NSLog(@"Starting to parse line");
    parsedFlag = YES;
    while ( methodId = [iter nextObject] ) 
      {
	funct = [[pdt valueForKey: methodId] pointerValue];
	dummy = [self performSelector: funct];
	NSLog(@"Parsed [%@]=[%@] via method [%@]",methodId,dummy,NSStringFromSelector(funct));
      }
  }
}


// Configuration

-(void)insertParserFunction:(NSValue *)aFunctionPtr 
		      after: (NSString *)aKey 
	     withIdentifier: (NSString *)ident;
{

  NSUInteger idx = [pdt indexOfKey: aKey];
  if (( idx != -1 && [pdt count] > 1)) {
    idx++;
    [pdt insertObject: aFunctionPtr forKey: ident atIndex: idx];
  } 
  else { 
    [pdt setObject: aFunctionPtr forKey: ident];
  }
}

-(void)insertParserFunction:(NSValue *)aFunctionPtr 
		     before: (NSString *)aKey 
	     withIdentifier: (NSString *)ident;
{

  NSUInteger idx = [pdt indexOfKey: aKey];
  if ([pdt count] > 0) {
    if (( idx != -1 )) {
      // If the key is not found, prepend it to the OrderedDictionary.
      [pdt insertObject: aFunctionPtr forKey: ident atIndex: 0]; 
    } 
    else 
      {
	idx == 0 ? idx=0 : idx--;
	[pdt insertObject: aFunctionPtr forKey: ident atIndex: idx]; 
      }
  } 
  else 
    { 
      // Dict is empty - just add it
      [pdt setObject: aFunctionPtr forKey: ident];
    }
}

-(void)addProviderClass:(id)aClass
{

}

// Testing 

-(BOOL)isParsed 
{
  return parsedFlag;
}

-(NSString *)description
{
  NSString *tmpStr;
  
  tmpStr = [NSString stringWithFormat: 
		       @"%@\n",
		     [super description]];
  return tmpStr;
}


@end
