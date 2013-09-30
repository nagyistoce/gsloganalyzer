/* -*- mode: ObjC; display-time-mode: on; mode: auto-complete -*-
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

#import "TKLogEntryParser.h"
#import "TKLogParserRegistry.h"
#import "GNUstepBase/GNUstep.h"

/*

TODO: The 
 */


@implementation TKLogParserRegistry

-(NSArray *)parserForLogType: (NSString *)aLogType includingDependencies:(BOOL)flag
{
  // Traverse parser to create a list of parsers
  // This needs to be normalized into TKLogEntryParser, TKLogEntryParserComposite
  // TODO: <DOCS> There can only be one baseparser for a logtype.
  NSMutableSet *parserSet = [[NSMutableSet alloc] init];
  NSString *currentLogType = aLogType;
  NSArray *result;
  while (1)
    {
      NSDictionary *parserDef = [self parserForLogType: currentLogType];
      if ( nil != parserDef && [parserDef count] > 0 && [currentLogType isEqualToString: @""] == NO)
	{
	  // Traverse extends
	  if ([parserSet containsObject: parserDef] == NO) // We do not have this, add it.
	    {
	      // Get the parser name
	      NSString *currentParserName = [[parserDef allKeys] objectAtIndex: 0]; 
	      // Traverse the current parser to get all parsers it extends
	      [parserSet addObjectsFromArray: 
			   [self parserIncludingDependenciesForName: currentParserName]]; // Add it to the set

	      // If this parser extends aLogType, make sure to traverse this as well by setting n and loop
	      currentLogType = [[parserDef valueForKey: currentParserName] 
				 valueForKey: @"extendslogtype"];
	    }
	}
      else
	break;
    }
  result = [parserSet allObjects];
  [parserSet release];
  return result;
}


-(id)parserForName: (NSString *)aName includingDependencies:(BOOL)flag
{

  // I will use a set since ordering is irrelevant at this point and
  // duplicates are unwanted given that we are storing the full parser dictionary
  // in the collection

  NSMutableSet *collected = [NSMutableSet setWithCapacity: 20];
  NSMutableSet *required = [NSMutableSet setWithCapacity: 30];
  NSString *currentName = aName;
  if (flag == YES) {
    while ([currentName isEqualToString: @""] == NO) 
      {
	NSDictionary *currentParserDef = [NSDictionary dictionaryWithDictionary: 
							   [parsers valueForKey: currentName]];

	if ( nil != currentParserDef && [currentParserDef count] > 0 ) 
	  {
	    [collected addObject: [NSDictionary dictionaryWithValuesAndKeys: currentParserDef, currentName, nil]];
	    currentName = [[currentParserDef valueForKey: currentName] valueForKey:@"extends"];
    	  }
	else 
	  break;
      }
    return AUTORELEASE(collected);
  }
  else
    {
	NSDictionary *currentParserDef = 
	  [NSDictionary dictionaryWithDictionary: [parsers valueForKey: currentName]];
	return currentParserDef;
    }
}


-(NSDictionary *)parserDefForLogType: (NSString *)aLogType 
{
  // TODO: <DOCS> There can only be one baseparser for a logtype.
  NSEnumerator *pIter = [parsers keyEnumerator];
  NSString *currentParserName;
  BOOL pFound = NO;
  NSDictionary *foundParser = nil;
  
  while (( currentParserName = [pIter nextObject]) && pFound == NO) 
    {
      // Get the dictionary for each parser
      NSDictionary *currentParserDef = [parsers valueForKey: currentParserName]; 
      if ( [[currentParserDef valueForKey:@"logtype"] isEqualToString: aLogType] == YES ) {
	  pFound = YES;
	  foundParser = [NSDictionary dictionaryWithObjectsAndKeys: currentParserDef,currentParserName,nil];
      }
    }
  return foundParser; // foundParser should already be autoreleased
}

-(id)init 
{
  self = [super init];
  if (nil != self) {
      NSDictionary *defsTA = [[NSUserDefaults standardUserDefaults] 
			       persistentDomainForName: @"TKLogAnalyzer"];
      if ( nil != defsTA ) {
	  parsers = [NSDictionary dictionaryWithDictionary: [defsTA objectForKey: @"Parsers"]];
	  [parsers retain];
	  //	  NSLog(@"Parsers read");
	}
    }
  return self;
}

-(void)dealloc
{
  [parsers release];
  [super dealloc];
}
@end
