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

#ifndef _LOGENTITY_H_
#define _LOGENTITY_H_

#import <Foundation/Foundation.h>
#import "DelimiterHandling.h"
#import "LogEntityParsing.h"

@interface LogEntity : NSObject
{
  int level;
  float probability;
  id delimiterHandler; 
  id parser;
  NSMutableArray *decendants; 
  id ancestor;
  id subject;
}

// Initialize-Release
-(LogEntity *)init;
-(LogEntity *)initWithObject: (id)anObj;
-(void)dealloc;

// Accessing
-(void)addDecendant: (LogEntity *)aLogEntity;
-(void)removeDecendant: (LogEntity *)aLogEntity;

/**  
anObject will be retained for the lifetime of the instance of the logEntity.

*/
-(void)setSubject:(id)anObject;

/**  

*/
-(id)subject;

/** 
This set the parent LogEntity for quick traversal.
It will also cause a cascade of level changes in all the decendants.
*/ 
-(void)setAncestor: (LogEntity *)aLogEntity;

/** 
The -setParser: and -setDelimiterHandler: sets the delegates for the -parse: method..
The delegates needs to conform to the <LogEntityParsing> protocol/ <DelimiterHandling> protocol.
Protocol is mostly there for to allow for DO enabled parsers/delimiter handlers.
Note: Remote DO processes might not be a good solution though given the network overhead, but I leave the idea in 
here and will build with the assumption that a parser or delimiterHandler might be a inter application process at one point.
*/
-(void)setParser: (id<LogEntityParsing>)aParser;
-(void)setDelimiterHandler: (id<DelimiterHandling>)aHandler;
-(int)level;
/**
     -setLevel: is recursive. it will traverse all the dependants and invoke -setLevel: on them.
*/
-(void)setLevel:(int)aLevel;

// Processing 
/**
The -parse; call will invoke the delimiterHandler to create a delimiterPositionArray.
The problem is that there might not be a uniform delimiter distribution in any given fragment.
I.e. a delimiterHandler can be configured to first break out {} patterns and then [] as a secondary choice. Since this cannot be passed into the delimiterHandler currently, cannot the LogEntity tree be constructed in one go.

This needs work!

 */
-(id)parse;
// Testing
-(BOOL)isRoot;
-(BOOL)isLeaf;
-(BOOL)hasDecendant:(LogEntity *)aLogEntity;

// Printing and Debugging
-(NSString *)description;

@end

#endif // _LOGENTITY_H_

