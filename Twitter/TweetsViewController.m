//
//  TweetsViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "DisplayCellTableViewCell.h"
#import "Tweet.h"
#import <UIImageView+AFNetworking.h>
#import "ComposeTweetViewController.h"
#import "LoginViewController.h"
#import "TweetDetailViewController.h"
#import "TimeLineViewController.h"
#import <UIKit/UIKit.h>


@interface TweetsViewController ()
@property (nonatomic,strong) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *displayView;
@property Tweet *tweetModel;
@property (nonatomic,strong) NSMutableArray *tweetInfo;
@property TwitterClient *client;
@property UIRefreshControl *refreshControl;
@property NSString *tweetId;

- (void)getTweets;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        // Custom initialization
        self.client = [TwitterClient instance];
        
    }
    return self;
}
- (void)addNewTweetButton
{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(250,20,50,40)];
    [button setTitle:@"New" forState:UIControlStateNormal];
    [button setTintColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newTweetClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 4.0f;
    [self.navigationController.view addSubview:button];
    
    
}

- (void)logOutClickEvent: (id) sender {

    [self.client deauthorize];
     LoginViewController *viewController = [[LoginViewController alloc] init];
     self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
  
}

- (void)newTweetClickEvent: (id) sender {
    //NSLog(@"%@", @"New Tweet Pressed");
    
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];

    UIColor *color = [self getUIColorObjectFromHexString:@"4099FF" alpha:.9];
    navigationController.navigationBar.barTintColor = color;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion: nil];
    
}



- (void)viewDidLoad
{
    NSLog(@"%@", @"view did load");
    [super viewDidLoad];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.displayView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    tableViewController.refreshControl = self.refreshControl;

    // Do any additional setup after loading the view from its nib.
        [self addNewTweetButton];
    
    [self getTweets];
}

- (void)onRefresh:(id)sender
{
    [self getTweets];
    NSLog(@"refresh");
    [self.refreshControl endRefreshing];
    
}

-(void)getTweets{
    
    if([self.testProp isEqual:@"hometimeline"])
    {
        [self.client homeTimelineWithSuccess:^ (AFHTTPRequestOperation *operation, id responseObject){
            //NSLog(@"response: %@", responseObject);
            self.tweetsArray = responseObject;
            [self.displayView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"response error: %@", error);
        }];
        
    }
    else{
        
    
    
    [self.client mentions:^ (AFHTTPRequestOperation *operation, id responseObject){
        self.tweetsArray = responseObject;
                [self.displayView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];
}
    self.displayView.dataSource = self;
    self.displayView.rowHeight = 120;
    
    [self.displayView registerNib:[UINib nibWithNibName:@"DisplayCellTableViewCell" bundle:nil] forCellReuseIdentifier: @"DisplayCellTableViewCell"];
    
    [self.displayView setDelegate:self];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetsArray.count;
    
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *selTweet = [self.tweetsArray objectAtIndex:indexPath.row];
    
    Tweet *selTweet = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[indexPath.row] error:NULL];
    
    NSLog(@"%ld", (long)selTweet.favouritesCount);
    
    TweetDetailViewController *detailViewController = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
     //[self colorWithHexString:@"FFFFFF"]
    
    UIColor *color = [self getUIColorObjectFromHexString:@"4099FF" alpha:.9];
    navigationController.navigationBar.barTintColor = color;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion: nil]; 
    
    
    //[self.navigationController pushViewController:detailViewController animated:YES];


    NSString *retweetCountString =  [NSString stringWithFormat:@"%d", selTweet.retweetCount];
    NSString *favoriteCountString = [NSString stringWithFormat:@"%d", selTweet.favouritesCount];
    BOOL isFavoriteBool = [selTweet.isFavorite boolValue];
    
    detailViewController.name = selTweet.name;
    detailViewController.displayName = selTweet.screenName;
    detailViewController.retweetedBy = selTweet.retweeted;
    detailViewController.tweet = selTweet.text;
    detailViewController.createdAt = selTweet.created;
    detailViewController.retweetCount = retweetCountString;
    detailViewController.favoriteCount = favoriteCountString;
    detailViewController.imageURL = selTweet.profileImageURL;
    detailViewController.isFavorite = isFavoriteBool;
    detailViewController.tweetId = selTweet.tweetId;
    
}

- (void)checkButtonTapped:(id)sender
{
    NSLog(@"clicked");
    UIButton *button = (UIButton *)sender;
    int tweetIdInt = [button tag];
   
    Tweet *model = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[tweetIdInt] error:NULL];
    
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    
    composeTweetViewController.tweetId = model.tweetId;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    UIColor *color = [self getUIColorObjectFromHexString:@"4099FF" alpha:.9];
    navigationController.navigationBar.barTintColor = color;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:navigationController animated:YES completion: nil];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
    NSLog(@" %@",self.tweetModel.isFavorite);
    NSString *isFav = self.tweetModel.isFavorite;
    NSLog(@"%@", isFav);
    BOOL flag = [self.tweetModel.isFavorite boolValue];
    NSLog(flag ? @"Yes" : @"No");
    if(flag)
    {
        displayCell.favoriteButton.selected = YES;
    }
    else
        displayCell.favoriteButton.selected = NO;
        

    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImagTap:)];
    
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [displayCell.thumbView addGestureRecognizer:tap];
    displayCell.thumbView.tag = indexPath.row;
    
    return displayCell;
    
}
- (void)profileImagTap:(id)recognizer
{
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)recognizer;
    
    NSLog(@"TAP Index %ld", (long)gesture.view.tag);
    
    TimeLineViewController *tvc = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
     tvc.userProfile = @"userprofile";

    Tweet *model = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[[(UIGestureRecognizer *)recognizer view].tag] error:NULL];
    
   tvc.userName = model.screenName;
    
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tvc];
    //[self colorWithHexString:@"FFFFFF"]
    
    UIColor *color = [self getUIColorObjectFromHexString:@"4099FF" alpha:.9];
    navigationController.navigationBar.barTintColor = color;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion: nil];
    

}

@end
