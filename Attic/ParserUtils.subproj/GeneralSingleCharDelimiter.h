/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-
x
   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Kack,,,

   Created: 2010-08-10 22:16:54 +0200 by tkack

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

#ifndef _GENERALSINGLECHARDELIMITER_H_
#define _GENERALSINGLECHARDELIMITER_H_

#import <Foundation/Foundation.h>
#import "DelimiterHandling.h"

@interface GeneralSingleCharDelimiter : NSObject <DelimiterHandling>
{
  NSData *aBuffer;
  NSMutableArray *ranges;
}

@end

#endif // _GENERALSINGLECHARDELIMITER_H_

