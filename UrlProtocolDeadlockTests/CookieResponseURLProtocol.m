//
//  CookieResponseURLProtocol.m
//  UrlProtocolDeadlock
//
//  Created by Michael Rhodes on 10/09/2015.
//  Copyright © 2015 Small Text. All rights reserved.
//

#import "CookieResponseURLProtocol.h"

static const NSString *EXPECTED_COOKIE = @"AuthSession=cm9vdDo1MEJCRkYwMjq0LO0ylOIwShrgt8y-UkhI-c6BGw; ";

@implementation CookieResponseURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request { 
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request { return request; }

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return NO;
}

- (void)startLoading
{
        NSURLRequest *request = [self request];
        id client = [self client];
        
        NSHTTPURLResponse *response;
        NSData *responseData;
        
        response = [[NSHTTPURLResponse alloc]
                    initWithURL:[request URL]
                    statusCode:200
                    HTTPVersion:@"HTTP/1.1"
                    headerFields:@{@"Set-Cookie" : [EXPECTED_COOKIE stringByAppendingString:
                                                    @"Version=1; Path=/; HttpOnly"]}];
        
        responseData = [NSJSONSerialization dataWithJSONObject:@{ @"ok" : @(YES),
                                                                  @"name" : @"username",
                                                                  @"roles" : @[ @"_admin" ] }
                                                       options:0
                                                         error:nil];
        [client URLProtocol:self
         didReceiveResponse:response 
         cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [client URLProtocol:self didLoadData:responseData];
        [client URLProtocolDidFinishLoading:self];
}

-(void)stopLoading
{
    // nothing
}

@end


@implementation AllForbiddenResponseURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request { 
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request { return request; }

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return NO;
}

- (void)startLoading
{
        NSURLRequest *request = [self request];
        id client = [self client];
        
        NSHTTPURLResponse *response;
        NSData *responseData;
        
        response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                               statusCode:401
                                              HTTPVersion:@"HTTP/1.1"
                                             headerFields:@{}];
        responseData = [NSData data];
        [client URLProtocol:self
         didReceiveResponse:response 
         cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [client URLProtocol:self didLoadData:responseData];
        [client URLProtocolDidFinishLoading:self];
}

-(void)stopLoading
{
    // nothing
}

@end
