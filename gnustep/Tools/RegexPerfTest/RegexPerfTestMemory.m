/* -*- mode: objc; fill-column: 120 */
#import <Foundation/Foundation.h>
#import <Performance/GSCache.h>


/* 
   TODO: I would like to the method lookup to cachable.
*/

/*
Protocol for all itemizer to conform to in order to be called.  This
guarantee that the -extractItemsFromString:addToDictionary: method exists and
it should return a NSString with all extracted items removed.
Returning an empty
The class method
+providesKeys should return a NSDictionary where the key will be the
key added to the itemDict when item is parsed.

The format of the item field found (and added to the itemDict) is the
following:

item
KEY ->(NSDictionary *details)
details
range->NSRange
value->NSString with the data found

The idea of having a dictionary in the itemDict per key is to be able
to extend what is provided at extractTime.

The protocol exists to not need to have a abstract superclass and to
work around multiple inheritence.

An example:

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

int
main (void)
{
  int x,y,arridx;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSError *error;

  NSLog(@"Setting up the Regex");
  NSRegularExpression *rx = [NSRegularExpression 
			      regularExpressionWithPattern: @"^((?:\\d{1,3}\\.){3}\\d{1,3})" 
						   options: 0 
						     error: &error];

  NSString *baseStr =  @".22.242.79 - _60291_1 [04/Apr/2012:07:00:03 -0700] \"GET /webapps/blackboard/execute/modulepage/view?course_id=_22480_1&cmp_tab_id=_43193_1 HTTP/1.1\" 200 45455 \"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0\" BCD89F24D5B9263CE39905830033845B 0.319 319 45455";
  NSLog(@"Building array");
  NSMutableArray *bigArr = [[NSMutableArray alloc] initWithCapacity: 256];
  for (arridx = 0;arridx < 256; arridx++) {
    [bigArr addObject: [NSString stringWithFormat: @"%i%@",arridx,baseStr]];
  }
  NSLog(@"Building array...done");
  NSString *s;
  int cnt;
  NSTextCheckingResult *t;
  NSRange foundRange;
  NSRange searchRange;


  NSLog(@"Starting extraction loops");
  cnt = 0;
  for (x = 0; x < 5000; x++) { 
    for (y = 0; y < 256; y++) {
      s =  [bigArr objectAtIndex: y];
      searchRange = NSMakeRange(0,[s length]);
      t = [rx firstMatchInString: s 
			 options: 0 
			   range: searchRange];
      foundRange = [t rangeAtIndex: 1];
      if (foundRange.length > 0) {
	cnt++;
      }
    }
  }
  NSLog(@"Starting extraction loops...done");
  NSLog(@"Found %i IPs",cnt); 
  [bigArr release];
  
  [pool release];
  return 0;
}
