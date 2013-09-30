/* -*- Mode: ObjC -*-

   Copyright (C) 2010 Free Software Foundation

   Author: Tim Kack,,,,

   Created: 2010-11-24 22:21:35 +0100 by timkack

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

#ifndef _TKACCESSLINE_H_
#define _TKACCESSLINE_H_

#import <Foundation/Foundation.h>
#import "TKLogEntryProvider.h"

@interface TKAccessLine : NSObject <TKLogEntryProvider>
{
  // Wrapping these up in a dictionary instead?
  NSUInteger reqSize;
  NSCalendarDate *reqDate;
  int reqStatus;
  NSString *reqSId;
  NSString *reqUri; // Should this be a NSURL so we can use -query;, -propertyForKey: methods?
  NSMutableDictionary *reqUriParams;
  NSString *reqIP;
  float reqTiS;
  NSUInteger reqTiMS;
  NSString *reqUA;
  NSString *reqUID;

  NSScanner *lineScanner;
  NSString *aLine;
}

// Class methods

// Defined in the LogEntryProvider protocol

// Initialize-release 

-(id)init;
-(void)dealloc;

// Accessors

/** 
   All getters will check if the line are parsed or not.
   This is of course a slight testing overhead and perhaps should be enforced in init... methods instead.
 */

-(NSDictionary *)components;
-(NSCalendarDate *)datetime;
-(NSString *)ip; // TODO: Perhaps wrap this in a struct with 4*1 bytes.
-(NSNumber *)requestSize;
-(NSString *)sessionId;
-(NSNumber *)status;
-(NSNumber *)timeInMilliSeconds;
-(NSNumber *)timeInSeconds;
-(NSString *)uri;
-(NSDictionary *)uriParameters;
-(NSString *)uriStem;
-(NSString *)userAgent;
-(NSString *)userId;

/**
   All setters are called by their getters if parsing is not done.
   This to ensure that the value is stored in a correct way.
   This means that all setters has only NSString as parameters, because external modifying functions needs to be able to assume
   an standard format.(I.e. stuff that modifies a uri after it has been parsed).
 */

-(void)setIP: (NSString *)aString;
-(void)setUserId: (NSString *)aString;
-(void)setDateTime: (NSString *)aString;
-(void)setUri: (NSString *)aString;

// Debugging - info
+(NSString *)description;
-(NSString *)description;

@end

#endif // _TKACCESSLINE_H_

