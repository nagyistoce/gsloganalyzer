/* -*- Mode: ObjC -*-

   Copyright (C) 2011 Free Software Foundation

   Author: tkack

   Created: 2011-01-18 10:56:08 +0100 by tkack

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

#ifndef _TKDUMMYLOGSINK_H_
#define _TKDUMMYLOGSINK_H_

#import <Foundation/Foundation.h>
#import "TKLogSource.h"

/**
   This class is just for testing the Parsers.
   TKDummyLogSink provides the same line over and over or limited to n;

 */


@interface TKDummyLogSink : NSObject <TKLogSource>
{
  NSUInteger n, c;
}


-(id)init;
-(void)dealloc;
-(void)setNumResultLines:(NSUInteger)anInteger;

@end

#endif // _TKDUMMYLOGSINK_H_

