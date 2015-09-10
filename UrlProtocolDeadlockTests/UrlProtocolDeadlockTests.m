//
//  UrlProtocolDeadlockTests.m
//  UrlProtocolDeadlockTests
//
//  Created by Michael Rhodes on 10/09/2015.
//  Copyright © 2015 Small Text. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <UrlProtocolDeadlock/CDTSessionCookeInterceptor.h>

#import "CookieResponseURLProtocol.h"


@interface UrlProtocolDeadlockTests : XCTestCase

@end

@implementation UrlProtocolDeadlockTests

- (void)testCookieInterceptorSuccessfullyGetsCookie
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.protocolClasses = @[ [CookieResponseURLProtocol class] ];
    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:config];
    
    NSString *expectedCookieString = @"AuthSession=cm9vdDo1MEJCRkYwMjq0LO0ylOIwShrgt8y-UkhI-c6BGw";
    
    CDTSessionCookeInterceptor *interceptor = [[CDTSessionCookeInterceptor alloc]
                                                initWithUsername:@"username"
                                                password:@"password"
                                                session:sharedSession];
    
    // create a context with a request which we can use
    NSURL *url = [NSURL URLWithString:@"cdtdatastore-cookie://username.cloudant.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSString *cookie = [interceptor newCookieForRemote:request.URL];
    
    XCTAssertEqualObjects(cookie, expectedCookieString);
    XCTAssertEqual(interceptor.shouldMakeCookieRequest, YES);
}
    
- (void)testCookieInterceptor401
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.protocolClasses = @[ [AllForbiddenResponseURLProtocol class] ];
    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:config];
    
    CDTSessionCookeInterceptor *interceptor = [[CDTSessionCookeInterceptor alloc]
                   initWithUsername:@"username"
                   password:@"password"
                   session:sharedSession];
    
    // create a context with a request which we can use
    NSURL *url = [NSURL URLWithString:@"cdtdatastore-401://username.cloudant.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSString *cookie = [interceptor newCookieForRemote:request.URL];
    
    XCTAssertNil(interceptor.cookie);
    XCTAssertEqual(interceptor.shouldMakeCookieRequest, NO);
    XCTAssertNil(cookie);
}

@end
