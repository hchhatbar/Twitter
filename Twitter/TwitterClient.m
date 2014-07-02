//
//  TwitterClient.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>

@interface TwitterClient()
@property (nonatomic, readwrite) BDBOAuth1SessionManager *networkManager;

@end

@implementation TwitterClient

+ (TwitterClient *) instance {
    
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"54A5GkfhEQnB6M2poGTEPF3MO" consumerSecret:@"nCwqwbwPaCQbwiVDYvxYeRV0DisKctaocUhEPWKl6UfSoSIUWR"] ;
    });
    
    return instance;
}

- (void)login{

    [self.requestSerializer removeAccessToken]; 
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get token: %@", error);
    }];
}

/*- (id)init
{
    self = [super init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/"];
    
    if (self) {
        self.networkManager = [[BDBOAuth1SessionManager alloc] initWithBaseURL:url
																   consumerKey:@"54A5GkfhEQnB6M2poGTEPF3MO"
																consumerSecret:@"nCwqwbwPaCQbwiVDYvxYeRV0DisKctaocUhEPWKl6UfSoSIUWR"];
    }
    
    return self;
   
}
*/

- (void)logOut{
    
	 [self deauthorize];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
    
}

- (AFHTTPRequestOperation *)userTimeLine:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:nil success:success failure:failure];
  
}

- (AFHTTPRequestOperation *)userProfile:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
     NSDictionary *parameters = @{@"screen_name": parameter}; //, @"location" : @"San Francisco"};
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:parameters success:success failure:failure];
    
}

- (AFHTTPRequestOperation *)mentions:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:success failure:failure];
    //return [self GET:@"1.1/users/show.json" parameters:@{@"screen_name":@"tasveer"}  success:success failure:failure];
}


- (AFHTTPRequestOperation *)updateStatus:(NSString *)parameter :(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    if([tweetId length] == 0)
    {
    return [self POST:@"1.1/statuses/update.json" parameters:@{@"status":parameter} success:success failure:failure];
    }
    else
     return [self POST:@"1.1/statuses/update.json" parameters:@{@"status":parameter, @"in_reply_to_status_id":tweetId} success:success failure:failure];
}

- (AFHTTPRequestOperation *)verifyCredentials:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
    
}

- (AFHTTPRequestOperation *)retweet:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", @"1.1/statuses/retweet/", parameter, @".json"];
    return [self POST:url parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)favorite:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    return [self POST:@"1.1/favorites/create.json" parameters:@{@"id":parameter} success:success failure:failure];
}


@end
