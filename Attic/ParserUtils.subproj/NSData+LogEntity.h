/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Käck

   Created: 2010-09-07 12:10:17 +0200 by tkack

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

#ifndef _NSDATA_LOGENTITY_H_
#define _NSDATA_LOGENTITY_H_

#import <Foundation/NSData.h>
#import "LogEntityParsing.h"
#import "DelimiterHandling.h"
#import "LogEntity.h"


@interface NSData (LogEntity)

/** 
-logEntity; will return a raw autoreleased LogEntityData instance.
No parser or delimiterHandler will be set, but the standard implementation
in LogEntityData will default to raising an NSInvalidArgument exception.
*/
-(LogEntity *)logEntity;

/**
-logEntityWithParser:delimiterHandler; creates a LogEntityData instance 
with the supplied Parser and DelimiterHandler. It is imperative that the Parser 
and DelimiterHandler conforms to their respective protocols. 
If greater flexibility is needed, use -logEntity instead.
 */
-(LogEntity *)logEntityWithParser:(id<LogEntityParsing>)aParser 
		      delimiterHandler:(id<DelimiterHandling>)aHandler;

@end

#endif // _NSDATA_LOGENTITY_H_

