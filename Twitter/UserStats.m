//
//  UserStats.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/30/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "UserStats.h"

@implementation UserStats

+ (NSDictionary *) JSONKeyPathsByPropertyKey{
    return @{
                @"tweetCount" : @"user.statuses_count",
                @"followingCount" : @"user.friends_count",
                @"followersCount" : @"user.followers_count",
                @"profileImageURL" : @"user.profile_image_url",
                @"backgroundImageURL" : @"user.profile_background_image_url",
             };
}


@end
