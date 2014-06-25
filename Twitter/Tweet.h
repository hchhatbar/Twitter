//
//  Tweet.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"

@interface Tweet : MTLModel<MTLJSONSerializing>

@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSString *retweeted;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *screenName;
@property(strong, nonatomic) NSString *created;
@property(strong, nonatomic) NSString *profileImageURL;
@property(assign, nonatomic) NSInteger retweetCount;
@property(assign, nonatomic) NSInteger favouritesCount;
@property(strong, nonatomic) NSString *isFavorite;
@property(strong, nonatomic) NSString *tweetId;

@end
