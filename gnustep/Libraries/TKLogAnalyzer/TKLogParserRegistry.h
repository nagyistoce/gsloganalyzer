/* -*- Mode: ObjC -*-
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

#ifndef _TKLOGPARSERREGISTRY_H_
#define _TKLOGPARSERREGISTRY_H_

#import <Foundation/Foundation.h>


@interface TKLogParserRegistry : NSObject
{
  NSDictionary *parsers;
}

-(id)init;
-(void)dealloc;
/**
-parserForLogType: returns a parser.
 */
-(NSDictionary *)parserDefForLogType: (NSString *)aLogType;
-(NSDictionary *)parserForName: (NSString *)aName;
/** 
-parserForName:includingDependencies; method either returns a NSDictionary with the parser dictionary
or a NSSet with NSDictionaries with the parser and dependent parsers.

If the parser is not found,  nil is returned.
If a required dependency is not found, nil is returned.
If a optional dependency is not found, the set is returned.
*/
-(id)parserForName: (NSString *)aName includingDependencies:(BOOL)flag;
-(id)parserForLogType: (NSString *)aLogType includingDependencies:(BOOL)flag;

@end

#endif // _TKLOGPARSERREGISTR_H_
