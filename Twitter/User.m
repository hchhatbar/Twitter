//
//  User.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (User *)currentUser{

    /*if(currentUser == nil){
        
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if(dictionary){
            currentUser = [[User alloc] initWithDictionary:dictionary];
            
        }
    }*/
    return currentUser;
}

+ (void)setCurrentUser:(User *)user{
    
    currentUser = user;
    //save to user defaults
}

@end
