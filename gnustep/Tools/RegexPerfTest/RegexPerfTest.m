#import <Foundation/Foundation.h>
#import <Performance/GSCache.h>

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


@interface Itemizer : NSObject 
{


}

@end;

@implementation Itemizer 

@end;


int
main (void)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  DDFileReader *reader = [[DDFileReader alloc] 
			   initWithFilePath: @"/Users/tkack/Documents/WorkNotes/LRNSI-7075/bb-access-logs/"
			   "bb-access-log.2012-04-04.prd1.txt"];
  NSString *regexStr = @"^((?:\\d{1,3}\\.){3}\\d{1,3})";
  NSError *error;
  NSRegularExpression *testRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
  NSString *line;/*
  ApacheItemizer works with Regexes to capture values.
  This is a problem since a Regex might capture a string that a subsequent parser should work with
  Consider this:

  1.2.3.4 "Record:[9922/12/12:22:22:22 -2000]UserId" "Action" [2012/01/01:21:21:11 -0300] "GET /some/Url HTTP/1.0" 200 1234 "Some agent" 

  Above is a specialized Tomcat log. ApacheItemizer would need to know
  to ignore "Record[....]", otherwise it might match the timestamp
  regex.

  The solution to this is all parsing needs to be done top-down, e.g:

  RecordItemizer parses:
  1.2.3.4 "Record:[9922/12/12:22:22:22 -2000]UserId" "Action:New" [2012/01/01:21:21:11 -0300] "GET /some/Url?file=bla HTTP/1.0" 200 1234 "Some agent" 
  And returns:
  1.2.3.4 "Action:New" [2012/01/01:21:21:11 -0300] "GET /some/Url?file=bla HTTP/1.0" 200 1234 "Some agent" 
  ActionItemizer parses and returns:
  1.2.3.4 [2012/01/01:21:21:11 -0300] "GET /some/Url?file=bla HTTP/1.0" 200 1234 "Some agent" 
  but it might also have parsed out file=bla from the uri. It should not delete it from the string unless it *owns* the field.

  But what if we want a Itemizer that works on an already itemized
  item (i.e. extract something from the dictionary passed around)?

  This is where dependencies comes into play!
  If an Itemizer needs another Itemizer to run first it Depends on it.
  If an Itemizer should run first (as in above example) it Extends it.

  These relations are considered when the Itemizer is creating its dispatch table.

 */

  int cnt = 0;
  while ((line = [reader readLine])) {
    NSTextCheckingResult *result = [testRegex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
    NSRange range = [result rangeAtIndex:1];
    if (range.length > 0) {
      cnt++;
    }
  }
  NSLog(@"Found %d ips",cnt); 
  [reader release];
  [pool drain];
  return 0;
}
