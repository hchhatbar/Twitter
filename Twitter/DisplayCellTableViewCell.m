//
//  DisplayCellTableViewCell.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "DisplayCellTableViewCell.h"

@interface DisplayCellTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLabelTopSpace;

@end
@implementation DisplayCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
- (void)setTweet: {
 if (self.tweet.retwetted) {
    
 }
 }

*/

@end
