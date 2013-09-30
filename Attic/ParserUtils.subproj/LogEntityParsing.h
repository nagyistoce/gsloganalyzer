/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Kack,,,

   Created: 2010-08-22 19:18:38 +0200 by tkack

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
LogEntityParsing defines a formal protocol for parsing classes that wish to be 
used with the LogEntity category in NSData, NSString etc.
Furthermore is the intention that this protocol will be subprotocolled for defining
a protocol for remote parsers
 */
@protocol LogEntityParsing <NSObject>

/**
-parseLogEntity: will be called in a target-action type of pattern.
Ex.
[someParser performSelector: @selector(parseLogEntity:) withObject: aLogEntity];

It is assumed that the parser returns a NSDictionary with key/value pair describing 
the logEntity.
*/
-(NSDictionary *)parseLogEntity:(id)aLogEntity;

/**
-parserDescription; should return a NSDictionary with the following structure:
KEY      | VALUE
=========+======================================
@"field1"| Description of "field1"
@"field2"| Description of "field2"
...
*/
-(NSDictionary *)parserDescription;
@end
