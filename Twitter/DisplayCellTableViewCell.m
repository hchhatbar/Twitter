//
//  DisplayCellTableViewCell.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "DisplayCellTableViewCell.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"

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

- (IBAction)replyClick:(id)sender {
  
}

- (IBAction)retweetClick:(id)sender {
    NSLog(@"clicked");
    TwitterClient *client = [TwitterClient instance];
    
    [client retweet:self.tweetId  success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
        
    }];

}

- (IBAction)favoriteClick:(id)sender {
    NSLog(@"clicked");
    TwitterClient *client = [TwitterClient instance];

    [client favorite:self.tweetId  success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        self.favoriteButton.selected = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
        
    }];

}
@end
