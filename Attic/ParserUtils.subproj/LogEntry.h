/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Käck

   Created: 2010-08-09 15:58:00 +0200 by tkack

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


/**


The LogEntry is compromised similar to the following structure:

[LOG ENTITY LEVEL 1] [LE L1] [LE L1]
       / \
      /   \
 [LE L2] [LE L2]
            \
             \
           [LE L3]

	   Two strategies can be used here:
	   1) Layer-by-layer: All L1 elements are scanned first, L2 later and L3 after that.
	   2) Recursive: First L1 element is scanned, First L2, First L3, return to second L2 etc


The advantage of 1) above is that a surface level scan can be done quite quickly and log format can be established if unknown.
The advantage of 2) is that the recursion will create several patterns which can be very useful for speeding up the parsing to follow.

I'll have to try both.


 */

#ifndef _LOGENTRY_H_
#define _LOGENTRY_H_

#import <Foundation/Foundation.h>

@interface LogEntry : NSObject
{
  NSMutableArray *entry;
}

@end

#endif // _LOGENTRY_H_

