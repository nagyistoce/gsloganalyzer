/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: tkack

   Created: 2010-08-09 15:57:22 +0200 by tkack

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

#import "LogEntity.h"

@interface LogEntity (private) <LogEntityParsing>

// Just a helper function
-(void)notConfiguredParserException;

@end


@implementation LogEntity (private)

-(void)notConfiguredParserException
{
  NSException *anException = [[NSException alloc]
			       initWithName: @"ParserConfigException"
				     reason: @"[Current logEntity does not have a valid Parser configured]"
				   userInfo: nil];
			   
  [anException raise];
}

-(NSDictionary *)parseLogEntity:(id)aLogEntity 
{
  [self notConfiguredParserException];
  return nil; // We do not expect to ever return from here, but to satisfy the compiler
}

-(NSDictionary *)parserDescription 
{
  [self notConfiguredParserException];
  return nil; // We do not expect to ever return from here, but to satisfy the compiler
}

@end


@implementation LogEntity

// Initialize-Release
-(LogEntity *)init 
{
  self = [super init];
  if (self != nil) {
    // Set ourselves as default parser and delimiterhandler
    // in case someone gets trigger happy
    [self setParser:self];
    [self setDelimiterHandler:self];
    level = 0;
    probability = 0.0;
    decendants = [[NSMutableArray alloc] init];
  }
  return self;
}

-(LogEntity *)initWithObject: (id)anObj 
{
  if ( [self init] != nil ) {
    [self setSubject: anObj];
  }
  return self;
}

-(void)dealloc 
{
  // Take care of subject, if it is allocated.
  if (subject != nil) [subject release];
  // Release the decendants. 
  // This Will cause NSMutableArry to invoke release on each of its contained LogEntities
  [decendants release]; 
  [delimiterHandler release];
  [super dealloc];
}

// Accessing

-(void)addDecendant: (LogEntity *)aLogEntity 
{
  /** 
      This will cause a cascade of -setLevel calls on aLogEntity.
   
  */
  if ([decendants containsObject: aLogEntity] == NO) {
    [aLogEntity setAncestor: self]; 
    [decendants addObject: aLogEntity];
  }
} 

-(void)removeDecendant: (LogEntity *)aLogEntity 
{
  [decendants removeObject: aLogEntity];
}

-(void)setAncestor: (LogEntity *)aLogEntity 
{
  [ancestor removeDecendant: self]; // First remove ourselves from the ancestors dependants collection
  [aLogEntity addDecendant: self]; // Add ourselves to the ancestor-to-be's decendants collection.
  ancestor = aLogEntity; // Finally set the ancestor
  [self setLevel: [ancestor level]+1]; // We now need to adjust the levels according to our new ancestor
}

-(int)level 
{
  return level;
}

-(void)setLevel: (int)aLevel 
{
  NSEnumerator *d = [decendants objectEnumerator];
  LogEntity *entity;
  level = aLevel;
  
  while ((entity = [d nextObject])) {
    [entity setLevel: aLevel+1];
  }
}

-(void)setDelimiterHandler: (id<DelimiterHandling>)aHandler 
{
  // TODO: Consider not retaining the delimiterHandler since it seems a bit unnecessary
  if (delimiterHandler != aHandler) {
    [delimiterHandler release];
    delimiterHandler = [aHandler retain];
  }
}

-(void)setParser:(id<LogEntityParsing>)aParser 
{
  // TODO: Consider not retaining the parser since it, just as with delimiterHandler to be a bit unnecessary
  if (parser != aParser) {
    [parser release];
    parser = [aParser retain];
  }
}

-(id)parse {


}

// Testing

-(BOOL)isRoot 
{
  return (ancestor  != nil) ? NO : YES;
}

-(BOOL)isLeaf 
{
  return ([decendants count] > 0) ? NO: YES;
}

-(BOOL)hasDecendant:(LogEntity *)aLogEntity 
{
  return [decendants containsObject: aLogEntity];
}

-(NSString *)description
{
  NSMutableString *d;
  d = [NSMutableString stringWithString: [super description]];
  [d appendFormat: @"\nDependants:\n%@", [decendants descripion]];
  return d;
}
@end



