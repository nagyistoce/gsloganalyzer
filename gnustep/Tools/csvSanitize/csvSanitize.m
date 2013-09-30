/* -*-ObjC-*-
   Project: CreateParserDict

   Copyright (C) 2011 Free Software Foundation

   Author: Tim Kack

   Created: 2011-01-06 16:09:34 +0100 by tkack

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

#import <Foundation/Foundation.h>

//DDFileReader.h

@interface DDFileReader : NSObject {
    NSString * filePath;

    NSFileHandle * fileHandle;
    unsigned long long currentOffset;
    unsigned long long totalFileLength;

    NSString * lineDelimiter;
    NSUInteger chunkSize;
}


-(void)setLineDelimiter: (NSString *)del;
-(NSString *)lineDelimiter;

- (id) initWithFilePath:(NSString *)aPath;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end


//DDFileReader.m

@interface NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind;

@end

@implementation NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind {

    const void * bytes = [self bytes];
    NSUInteger length = [self length];

    const void * searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    NSUInteger searchIndex = 0;

    NSRange foundRange = {NSNotFound, searchLength};
    NSUInteger index;
    for (index = 0; index < length; index++) {
        if (((char *)bytes)[index] == ((char *)searchBytes)[searchIndex]) {
            //the current character matches
            if (foundRange.location == NSNotFound) {
                foundRange.location = index;
            }
            searchIndex++;
            if (searchIndex >= searchLength) { return foundRange; }
        } else {
            searchIndex = 0;
            foundRange.location = NSNotFound;
        }
    }
    return foundRange;
}

@end

@implementation DDFileReader

- (NSString *)lineDelimiter 
{
  return lineDelimiter;
}

- (void)setLineDelimiter: (NSString *)del
{
  if (lineDelimiter != del) {
    [lineDelimiter release];
    lineDelimiter = [del copy];
  }
}

-(NSUInteger) chunkSize 
{
  return chunkSize;
}

- (id) initWithFilePath:(NSString *)aPath {
    if (self = [super init]) {
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:aPath];
        if (fileHandle == nil) {
            [self release]; return nil;
        }

        lineDelimiter = [[NSString alloc] initWithString:@"\n"];
        [fileHandle retain];
        filePath = [aPath retain];
        currentOffset = 0ULL;
        chunkSize = 1024;
        [fileHandle seekToEndOfFile];
        totalFileLength = [fileHandle offsetInFile];
        //we don't need to seek back, since readLine will do that.
    }
    return self;
}

- (void) dealloc {
    [fileHandle closeFile];
    [fileHandle release], fileHandle = nil;
    [filePath release], filePath = nil;
    [lineDelimiter release], lineDelimiter = nil;
    currentOffset = 0ULL;
    [super dealloc];
}

- (NSString *) readLine {
    if (currentOffset >= totalFileLength) { return nil; }

    NSData * newLineData = [lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle seekToFileOffset:currentOffset];
    NSMutableData * currentData = [[NSMutableData alloc] init];
    BOOL shouldReadMore = YES;

    NSAutoreleasePool * readPool = [[NSAutoreleasePool alloc] init];
    while (shouldReadMore) {
        if (currentOffset >= totalFileLength) { break; }
        NSData * chunk = [fileHandle readDataOfLength:chunkSize];
        NSRange newLineRange = [chunk rangeOfData_dd:newLineData];
        if (newLineRange.location != NSNotFound) {

            //include the length so we can include the delimiter in the string
            chunk = [chunk subdataWithRange:NSMakeRange(0, newLineRange.location+[newLineData length])];
            shouldReadMore = NO;
        }
        [currentData appendData:chunk];
        currentOffset += [chunk length];
    }
    [readPool release];

    NSString * line = [[NSString alloc] initWithData:currentData encoding:NSUTF8StringEncoding];
    [currentData release];
    return [line autorelease];
}

- (NSString *) readTrimmedLine {
    return [[self readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL*))block {
  NSString * line = nil;
  BOOL stop = NO;
  while (stop == NO && (line = [self readLine])) {
    block(line, &stop);
  }
}
#endif

@end


int
main (void)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  DDFileReader *reader = [[DDFileReader alloc] 
			   initWithFilePath: @"J:\\Work\\AS-155271\\Investigation\\"
			   "3.3.2011.csv"];



  NSString * line = nil;
  NSUInteger cc,c = 0;
  NSFileHandle *newCSVfile;
  NSString *outfilename = [NSString stringWithString: @"C:\\332011-san.csv"];
  newCSVfile = [NSFileHandle fileHandleForWritingAtPath:outfilename];
  [newCSVfile truncateFileAtOffset:[newCSVfile seekToEndOfFile]];
  // Add header
  NSString * hdr = @"parent_id,start_date,end_date,dtcreated,type,title,owner_pk1,crs_contents_pk1,parent_content_pk1,crsmain_pk1,source_id,source_type,event_type,due_date,data_pending_ind,can_replace_ind,important_ind,override_setting_ind,default_receiver_status,default_sender_status,pk1,course_name,service_level,group_pk1,recipient_user_pk1,user_type,group_name\n\r";

  [newCSVfile writeData:[hdr dataUsingEncoding:NSUTF8StringEncoding]];  

  while ((line = [reader readLine])) {
    //    NSLog(@"read line: %@", line);
    c++;
    cc++;
    NSString *replacedString = [line stringByReplacingOccurrencesOfString:@",NULL," withString:@",,"];
    replacedString = [replacedString stringByReplacingOccurrencesOfString:@", " withString:@"~ "];

    if (cc > 50000) {
      printf("%u... ",c);
      cc=0;
    }
    [newCSVfile writeData:[replacedString dataUsingEncoding:NSUTF8StringEncoding]];
    //    [replacedString release];
  }
  [reader release];
  [newCSVfile closeFile];
  NSLog(@"The file has %u lines", c);
  [pool drain];
  return 0;
}
