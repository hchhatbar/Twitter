//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/24/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"

@interface TweetDetailViewController ()

@property TwitterClient *client;
@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.client = [TwitterClient instance];
    }
    return self;
}

- (void)addCancelAndTweetButtons
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
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setFrame:CGRectMake(250,20,60,40)];
    [searchButton setTitle:@"Reply" forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor redColor]];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(replyClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    searchButton.layer.borderColor = [UIColor clearColor].CGColor;
    searchButton.layer.borderWidth = 1.0f;
    searchButton.layer.cornerRadius = 4.0f;
    [self.navigationController.view addSubview:searchButton];
    
    
}

- (void)homeClickEvent: (id) sender {
    NSLog(@"%@", @"Home Pressed");
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)replyClickEvent: (id) sender {
    
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    
    composeTweetViewController.tweetId = self.tweetId;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion: nil];
    
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.retweetedByLabel.text = self.retweetedBy;
    self.nameLabel.text = self.name;
    self.displayNameLabel.text = self.displayName;
    self.tweetLabel.text = self.tweet;
    self.createdAtLabel.text = self.createdAt;
    self.retweetCountLabel.text = self.retweetCount;
    self.favoriteCountLabel.text = self.favoriteCount;
    
    if([self.retweetedBy length] == 0)
    {
        self.retweetImage.hidden = YES;
    }
    
    if(self.isFavorite)
    {
        self.favoriteButton.selected = YES;
    }
    else
                self.favoriteButton.selected = NO;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
    self.thumbView.image =[UIImage imageWithData:imageData];
    
    [self addCancelAndTweetButtons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retweetClick:(id)sender {
    
    [self.client retweet:self.tweetId  success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
       
    }];

}

- (IBAction)favoriteClick:(id)sender {
    [self.client favorite:self.tweetId  success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        
        //[self dismissViewControllerAnimated:YES completion:nil];
                self.favoriteButton.selected = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
        
    }];

}

- (IBAction)replyClick:(id)sender {
    
    NSLog(@"click");
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    
    composeTweetViewController.tweetId = self.tweetId;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion: nil];
    

}
@end
