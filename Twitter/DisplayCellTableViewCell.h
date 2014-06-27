//
//  DisplayCellTableViewCell.h
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;

@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) NSString *tweetId;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


- (IBAction)replyClick:(id)sender;
- (IBAction)retweetClick:(id)sender;
- (IBAction)favoriteClick:(id)sender;



//@property (strong, nonatomic) Tweet *tweet;
@end
