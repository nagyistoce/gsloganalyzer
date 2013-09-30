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

#ifndef _TKLOGENTRYPARSER_H_
#define _TKLOGENTRYPARSER_H_

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

@interface TKLogEntryParser : NSObject
{
  NSDictionary *definition;
  NSArray *subParsers;
  NSString *parserName;
}

// Convenience constructors


// Initialize-Release

-(id)init;
-(void)dealloc;


// Configuration 


// Accessors


// Actions


// Testing
-(BOOL)isComposite;

-(NSString *)description;

@end

#endif // _TKLOGENTRYPARSER_H_

