// -*- Mode: ObjC; Mode: auto-complete; Mode: outline-minor -*-
#import "ParserUtilsTests.h"
#import "LogEntityTest.h"

@implementation ParserUtilsTests

+(ParserUtilsTests *)suite 
{
  return [[[self alloc] initWithName: @"ParserUtils component tests"] autorelease];
}

-(id)initWithName: (NSString *)aName 
{
  self = [super initWithName:aName];

  [self addTest:[TestSuite suiteWithClass:[LogEntityTest class]]];

  return self;
}

@end
