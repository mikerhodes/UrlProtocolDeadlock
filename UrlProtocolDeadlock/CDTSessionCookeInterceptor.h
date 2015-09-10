//
//  CDTSessionCookeInterceptor.h
//  UrlProtocolDeadlock
//
//  Created by Michael Rhodes on 10/09/2015.
//  Copyright © 2015 Small Text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTSessionCookeInterceptor : NSObject

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
                         session:(NSURLSession *)session;

- (nullable NSString *)newCookieForRemote:(NSURL *)url;

@property (nonnull, strong, nonatomic) NSString *cookieRequestBody;
@property (nonatomic) BOOL shouldMakeCookieRequest;
@property (nullable, strong, nonatomic) NSString *cookie;
@property (nonnull, nonatomic, strong) NSURLSession *urlSession;

@end
