//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/24/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
- (IBAction)retweetClick:(id)sender;
- (IBAction)favoriteClick:(id)sender;
- (IBAction)replyClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *retweetedBy;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *tweet;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *retweetCount;
@property (nonatomic, strong) NSString *favoriteCount;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) BOOL isFavorite;


@end
