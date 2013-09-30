/* -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-

   Project: ParserUtils

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Kack,,,

   Created: 2010-08-22 19:17:23 +0200 by tkack

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
The DelimiterHandling protocol needs to be implemented by any object that wants to 
be a delmiterHandler for a LogEntity.
The delimiterHandler will always be called in a 


 */
@protocol DelimiterHandling <NSObject>

// Setters

/**
This sets the max length for the DelmiterHandler to  search in the buffer.
It is assumed that if this is not set, the DelimiterHandler will search upto 
the end of the buffer.
 */
-(void)setMaxLengthToSearch: (NSUInteger *)aSize;  

/**
This methods  set the start marker object.
What object type that is, is up to the object that implements the 
DelimiterHandling protocol.
 */
-(void)setStartDelimiter: (id) aDelimiter;

/**
See -setStartDelimiter:. This the object that marks the end of an LogEntity
 */
-(void)setEndDelimiter: (id) aDelimiter;


// Getters

/**
The implementor of this method needs to return an NSArray will rangeValues.

Consider the following log entries, where here is () used as delimiters
<example>
                  1         2         3
         123456789012345678901234567890
---------------------------------------
Entry 1: (some data)  (some more data)
Entry 2: (some (some more data) data)
</example>

In this example should this method return an NSArray with two NSRanges encoded asNSValues.
The array from Entry 1 would look like this:
NSRange(2,9), NSRange(15,14)
But Entry 2's would look quite different where the start for range 2 location 
overlap the length overlap the length of range 1:
NSRange(2,26), NSRange(8,17)

 */
-(NSArray *)scanDelimiterPositionsOn:(id)anObject;

/**
If -hasIncompleteDelimiters; returns true, this method can be called to get the 
stray startDelimiter(s).
Just as in -scanDelimiterPositionsOn: is it expect to return an NSArray with NSValue 
contained integers.
 */
-(NSArray *)incompleteStartDelimiterLocations; 
/** 
Should flag YES if the matches has been found but there is one start or end marker 
missing, i.e. the logmatching is not complete.
 */
-(BOOL)hasIncompleteDelimiters;

/**
See -incompleteStartDelimiterLocations; 
 */
-(NSArray *)incompleteEndDelimiterLocations;
/** 
Test for linefeed and/or carriage returns between a startDelimiter and an endDelimiter
*/
-(BOOL)spansSeveralLines;

@end
