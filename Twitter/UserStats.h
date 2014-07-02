//
//  UserStats.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/30/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "Mantle/Mantle.h"

@interface UserStats : MTLModel<MTLJSONSerializing>

@property(assign, nonatomic) NSString *tweetCount;
@property(assign, nonatomic) NSString *followingCount;
@property(assign, nonatomic) NSString *followersCount;
@property(strong, nonatomic) NSString *profileImageURL;
@property(strong, nonatomic) NSString *backgroundImageURL;
@end
