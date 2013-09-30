/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: tkack

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

#import "NSString+LogEntity.h"

@implementation NSString (LogEntity)

-(LogEntity *)logEntity 
{
  LogEntity  *tmpLE = [[LogEntity alloc] initWithObject: self];
  if (tmpLE != nil) 
    return [tmpLE autorelease];
  else
    return nil;
}

-(LogEntity *)logEntityWithParser:(id <LogEntityParsing>)aParser 
		     delimiterHandler:(id <DelimiterHandling>)aHandler 
{
  LogEntity *tmpLE = [[LogEntity alloc] initWithObject: self];
  if (tmpLE != nil && 
      [aParser conformsToProtocol: @protocol(LogEntityParsing)] == YES &&
      [aHandler conformsToProtocol: @protocol(DelimiterHandling)] == YES)
    {
      [tmpLE setParser: aParser];
      [tmpLE setDelimiterHandler: aHandler];
      return [tmpLE autorelease];
    }
  else
    return nil;
}

@end
