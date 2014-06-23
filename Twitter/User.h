//
//  User.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

@end
