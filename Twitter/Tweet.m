//
//  Tweet.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

//@"retweeted_status.created_at"
+ (NSDictionary *) JSONKeyPathsByPropertyKey{
    return @{@"text" : @"text",
             @"retweeted" : @"retweeted_status.entities.user_mentions.name",
             @"name" : @"user.name",
             @"screenName" : @"user.screen_name",
             @"created" : @"created_at",
             @"profileImageURL" : @"user.profile_image_url"
             };
}

+ (NSValueTransformer *)retweetedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *retweet) {
        if(![retweet count])
        {
            //NSLog(@"empty");
            return @"";
        }
        else
        {
            NSString *ret = [retweet objectAtIndex:0];
            //NSLog(@"%@", ret);
            return [NSString stringWithFormat:@"Retweeted By %@",ret];
        }
        
    }];
}


/*+ (NSDateFormatter *)createdFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSLog(@"%@", dateFormatter);
    return dateFormatter;
} */

+ (NSValueTransformer *)createdJSONTransformer {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
            NSLog(@"%@", @"date");
            NSLog(@"%@", str);
            NSString *formattedDateString;
            
            
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            NSDate* dateOutput = [dateFormatter dateFromString:str];
            
            NSTimeInterval elapsedTimeInterval = [dateOutput timeIntervalSinceNow];
            int elapsedSeconds = (int)(elapsedTimeInterval * -1);
            
            NSLog(@"%d", elapsedSeconds);
            
            if (elapsedSeconds < 60) {
                formattedDateString = @"now";
            }
            else if (elapsedSeconds < 3600) {
                int minutes = elapsedSeconds / 60;
                formattedDateString = [NSString stringWithFormat:@"%dm", minutes];
            }
            else if (elapsedSeconds < 86400) {
                int hours = elapsedSeconds / 3600;
                formattedDateString = [NSString stringWithFormat:@"%dh", hours];
            }
            else if (elapsedSeconds < 31536000) {
                int days = elapsedSeconds / 86400;
                formattedDateString = [NSString stringWithFormat:@"%dd", days];
            }
            else {
                int years = elapsedSeconds / 31536000;
                formattedDateString = [NSString stringWithFormat:@"%dyr", years];
            }
            
            NSLog(@"%@", formattedDateString);
            return formattedDateString;
            
        } reverseBlock:^(NSString *date) {
            return date;
        }];
    }

@end
