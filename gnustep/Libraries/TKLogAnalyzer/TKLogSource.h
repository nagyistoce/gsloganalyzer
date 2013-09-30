/* -*- Mode: ObjC -*-

   Copyright (C) 2011 Free Software Foundation

   Author: tkack

   Created: 2011-01-18 10:55:44 +0100 by tkack

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

@protocol TKLogSource <NSObject>

/**
   return the next available string to the caller.
 */
-(NSString *)nextString;
/**
   Answer YES if this LogSink can handle multiple lines. 
   This is for use with LogEntryParsers that needs multiple lines in order to 
   complete one LogEntry
 */
-(BOOL)canHandleMultipleLines;
/**
   Answer YES if we are at the end of the log source.
 */
-(BOOL)isAtEnd;
/**
   Answer YES if there are more data to be retrieve via -nextString;. 
   If this is NO, it does not necessarily mean that the log source is at end.
 */
-(BOOL)hasMoreData;

@end
