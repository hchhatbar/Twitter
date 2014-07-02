//
//  TimeLineViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/30/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "TimeLineViewController.h"
#import "TwitterClient.h"
#import "UserStats.h"
#import "Tweet.h"
#import "DisplayCellTableViewCell.h"
#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface TimeLineViewController ()
@property TwitterClient *client;
@property (nonatomic,strong) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property Tweet *tweetModel;
@property (weak, nonatomic) IBOutlet UITableView *displayView;
//@property NSString *userProfile;


@end

@implementation TimeLineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.client = [TwitterClient instance];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([self.userProfile isEqual:@"userprofile"])
    {
        [self.client userProfile:self.userName  success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            //NSLog(@"response: %@", responseObject);
            //[self dismissViewControllerAnimated:YES completion:nil];
            self.tweetsArray = responseObject;
            UserStats *userStat = [MTLJSONAdapter modelOfClass:UserStats.class fromJSONDictionary:self.tweetsArray[0] error:NULL];
            
            self.tweetCountLabel.text =  [NSString stringWithFormat:@"%@", userStat.tweetCount];
            self.followersCountLabel.text = [NSString stringWithFormat:@"%@", userStat.followersCount];
            self.followingCount.text = [NSString stringWithFormat:@"%@", userStat.followingCount];
            
            
            NSString *url = [userStat.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.profileImageURL]];
            self.thumbView.image =[UIImage imageWithData:imageData];
            
            NSData *backgroundImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.backgroundImageURL]];
            self.backgroundView.image =[UIImage imageWithData:backgroundImageData];
             [self addHomeButton];
            [self.displayView reloadData];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"response error: %@", error);
            
        }];
        
    }
    else
    {
        [self.client userTimeLine:^ (AFHTTPRequestOperation *operation, id responseObject){
            //NSLog(@"response: %@", responseObject);
            self.tweetsArray = responseObject;
            UserStats *userStat = [MTLJSONAdapter modelOfClass:UserStats.class fromJSONDictionary:self.tweetsArray[0] error:NULL];
            
            self.tweetCountLabel.text =  [NSString stringWithFormat:@"%@", userStat.tweetCount];
            self.followersCountLabel.text = [NSString stringWithFormat:@"%@", userStat.followersCount];
            self.followingCount.text = [NSString stringWithFormat:@"%@", userStat.followingCount];
            
            
            NSString *url = [userStat.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.profileImageURL]];
            self.thumbView.image =[UIImage imageWithData:imageData];
            
            NSData *backgroundImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.backgroundImageURL]];
            self.backgroundView.image =[UIImage imageWithData:backgroundImageData];
            [self.displayView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"response error: %@", error);
        }];
    }
    
  
    self.displayView.rowHeight = 120;
    
    [self.displayView registerNib:[UINib nibWithNibName:@"DisplayCellTableViewCell" bundle:nil] forCellReuseIdentifier: @"DisplayCellTableViewCell"];
    
      self.displayView.dataSource = self;
    
    [self.displayView setDelegate:self];
    


}

- (void)addHomeButton
{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10,20,60,40)];
    [button setTitle:@"Home" forState:UIControlStateNormal];
    [button setTintColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(homeClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 4.0f;
    [self.navigationController.view addSubview:button];
    

    
    
}

- (void)homeClickEvent: (id) sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkButtonTapped:(id)sender
{
    NSLog(@"clicked");
   }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetsArray.count;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select");
    
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSLog(@"cell for row");
    
    DisplayCellTableViewCell *displayCell = [tableView dequeueReusableCellWithIdentifier:@"DisplayCellTableViewCell"];
    
    
    self.tweetModel = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[indexPath.row] error:NULL];
    NSLog(@" %@",self.tweetModel.retweeted);
    [displayCell.replyButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.tweetModel.retweeted length] == 0 )
    {
        displayCell.retweetHeight.constant = 0.0f;
        displayCell.topHeight.constant = 0.0f;
        displayCell.retweetImageView.hidden = YES;
    }
    else
        displayCell.retweetLabel.text = self.tweetModel.retweeted;
    displayCell.replyButton.tag  = indexPath.row;
    displayCell.tweetId = self.tweetModel.tweetId;
    displayCell.tweetLabel.text = self.tweetModel.text;
    
    displayCell.createdLabel.text = self.tweetModel.created;
    displayCell.nameLabel.text =  [NSString stringWithFormat:@"%@ @%@", self.tweetModel.name, self.tweetModel.screenName ];
    
    displayCell.retweetButton.hidden = YES;
    displayCell.replyButton.hidden = YES;
    displayCell.favoriteButton.hidden = YES;
    
    
    
    //   NSLog(@"name Label: %@", self.tweetModel.profileImageURL);
    
    NSString *imgURL = [self.tweetModel.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    NSURL   *imageURL   = [NSURL URLWithString:imgURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    UIImage *placeholderImage; // = [UIImage imageNamed:@"yelp_placeholder.png"];
    
    __weak UITableViewCell *weakCell = displayCell;
    
    
    [displayCell.thumbView setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              weakCell.imageView.image = image;
                                              weakCell.imageView.layer.cornerRadius = 15.0;
                                              weakCell.layer.masksToBounds = YES;
                                              
                                              [weakCell setNeedsLayout];
                                              
                                              
                                          } failure:nil];
    
    return displayCell;
    
}


@end
