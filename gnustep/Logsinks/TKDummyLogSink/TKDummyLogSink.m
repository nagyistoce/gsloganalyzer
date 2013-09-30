/*
   Project: compareUriStems.project

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

#import "TKDummyLogSink.h"

@implementation TKDummyLogSink

-(id)init 
{
  self = [super init];
  if (self != nil)
    {
      n = -1; // -1 is unlimited
      c = 0;
    }
}

-(void)dealloc
{
  [super dealloc];
}

-(void)setNumResultLines:(NSUInteger)anInteger
{
  n = anInteger;
}

-(BOOL)isAtEnd 
{
  return (n==c) ? YES : NO;
}

-(BOOL)canHandleMultipleLines
{
  return NO;
}

-(BOOL)hasMoreData
{
  return (n==c) ? YES : NO;
}

-(NSString *)nextString
{
 NSString *aLine = [NSString stringWithString:
@"81.104.162.76"
" - _678896_1"
" [11/Oct/2010:00:00:01 +0100]"
" \"GET /webapps/application/subdirectory/jsp.jsp?param_id=1&otherParam=Cool&href=http%3A%2F%2Flibrary.cf.ac.uk%2F&courseTocLabel=Voyager HTTP/1.1\""
" 200 2323"
" \"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.10) Gecko/20100914 Firefox/3.6.10\""
" 9B4FCA60801ACED01F2C234AA53C02AD "
"0.009 9 2323"];
 c++;
 if (n != -1 && c>n)
   {
     return nil;
   }
 else
   {
     return aLine; // It is already autoreleased
   }
}


@end
