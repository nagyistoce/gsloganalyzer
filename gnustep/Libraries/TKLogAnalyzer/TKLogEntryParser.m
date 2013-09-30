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

#import "TKLogEntryParser.h"
#import "GNUstepBase/GNUstep.h"

@implementation TKLogEntryParser

/*
  Initialize-release
*/

-(id)init 
{
  self = [super init];
  if (self != nil) 
    {
    }
  return self;
}

-(void)dealloc 
{
  [super dealloc];
}

// Testing 

-(BOOL)isComposite
{
  return nil != subParsers ? YES : NO;
}


-(NSString *)description
{
  NSString *tmpStr;
  
  tmpStr = [NSString stringWithFormat: @"%@\n", [super description]];
  // tmpStr = [NSString stringWithFormat: 
  // 		       @"%@\n"
  // 		       "\n==== LOGENTRYPARSER: OBJECT PROPERTIES ====\n"
  // 			   "      PDT:(%@)\n"
  // 			   " RAW LINE:(%@)\n"
  // 		       "\n==== LOGENTRYPARSER: OBJECT STATUS ====\n"
  // 		           "   PARSED:(%@)\n",
  // 		     [super description],pdt,
  // 		     currentLine,
  // 		(parsedFlag ? @"YES" : @"NO")];
  return tmpStr;
}

@end
