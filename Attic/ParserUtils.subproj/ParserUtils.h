/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Käck

   Created: 2010-08-09 15:53:07 +0200 by tkack

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

#ifndef _PARSERUTILS_H_
#define _PARSERUTILS_H_

#import <Foundation/Foundation.h>
/**

This needs to be a singleton factory.


There is three algorithms that will be used:

1) Known pattern(s) for the specific LogStream.
1.1) The pattern(s) is demarshalled from an XML file (or proplist) into a series of possible LogEntities.
1.2) The log is then iteravitely  analyzed by creating LogEntries containing data populated LogEntities
This forms a LogEntry. The LogEntry contains only a tree of seen LogEntitites.
1.3) The LogEntry is then used to update the probabilities in the possible LogEntitites tree
-- The idea behind this is that the ParserUtil can be asked at certain intervals for the adjusted probabilities
and an updated marshalled XML pattern can be stored for future use.

2) Unknown patterns in the LogStream
This process is much more involved and needs a fairly big chunk of log to work on.
2.1) A Level 1 LogEntity is created. It has GenericCharacterDelimiter assigned to it which is loaded with a set of delimiter pairs

TODO: Finish off this description.

*/

@interface ParserUtils : NSObject
{
  NSData *buffer;
 }

// Initialize-Release

-(ParserUtils *)init;
-(void)dealloc;

// Accessing

// Methods for examining the data

/** 
-knownLogFormats; returns a NSDictionary with all known (and loaded log formats, see -loadLogPattersFrom:(NSURL *)anUrl;
 */
-(NSDictionary *)knownLogFormats;  


/*
..--== Stuff ==--..

Some ideas:

Stream everything, even local files using an NSData buffer. If net protocol used is not file:/// allow for local buffering of stream and use this for peeking back
Implement a bundle manager for Parsers and DelimiterHandlers.




 */



// Testing


@end
#endif // _PARSERUTILS_H_

