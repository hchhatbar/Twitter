//
//  TwitterClient.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>


@interface TwitterClient : BDBOAuth1RequestOperationManager

@property (nonatomic, readonly) BDBOAuth1SessionManager *networkManager;

+ (TwitterClient *) instance;

- (void)login;
- (void)logOut;



- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)updateStatus:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)verifyCredentials:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




@end
