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


@interface TweetsViewController ()
@property (nonatomic,strong) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *displayView;
@property Tweet *tweetModel;
@property (nonatomic,strong) NSMutableArray *tweetInfo;
@property TwitterClient *client;
@property UIRefreshControl *refreshControl;

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
    
    
    UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logOutButton setFrame:CGRectMake(25,20,75,40)];
    [logOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    [logOutButton setTintColor:[UIColor redColor]];
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOutButton addTarget:self action:@selector(logOutClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    logOutButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    logOutButton.layer.borderColor = [UIColor clearColor].CGColor;
    logOutButton.layer.borderWidth = 1.0f;
    logOutButton.layer.cornerRadius = 4.0f;
    [self.navigationController.view addSubview:logOutButton];
    
    
}

- (void)logOutClickEvent: (id) sender {

    [self.client deauthorize];
     LoginViewController *viewController = [[LoginViewController alloc] init];
     self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
  
}

- (void)newTweetClickEvent: (id) sender {
    NSLog(@"%@", @"New Tweet Pressed");
    
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion: nil];
    
}



- (void)viewDidLoad
{
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
    
    [self.client homeTimelineWithSuccess:^ (AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"tweets table view controller");
        NSLog(@"response: %@", responseObject);
        self.tweetsArray = responseObject;
        //NSLog(@"array count: %d", [self.tweetsArray count]);
        //NSLog(@"%@", self.tweetsArray[1]);
        [self.displayView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];

    self.displayView.dataSource = self;
    self.displayView.rowHeight = 130;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *selTweet = [self.tweetsArray objectAtIndex:indexPath.row];
    
    Tweet *selTweet = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[indexPath.row] error:NULL];
    
    NSLog(@"%@", selTweet.favouritesCount);
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    DisplayCellTableViewCell *displayCell = [tableView dequeueReusableCellWithIdentifier:@"DisplayCellTableViewCell"];
    
    self.tweetModel = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[indexPath.row] error:NULL];
    displayCell.tweetLabel.text = self.tweetModel.text;
    displayCell.retweetLabel.text = self.tweetModel.retweeted;
    displayCell.createdLabel.text = self.tweetModel.created;
    displayCell.nameLabel.text =  [NSString stringWithFormat:@"%@ @%@", self.tweetModel.name, self.tweetModel.screenName ];
    
    NSLog(@"name Label: %@", self.tweetModel.profileImageURL);

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
