//
//  TimeLineViewController.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/30/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property NSString *userProfile;
@property NSString *userName;
@end
