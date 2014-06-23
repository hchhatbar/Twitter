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

@interface TweetsViewController ()
@property (nonatomic,strong) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *displayView;
@property Tweet *tweetModel;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TwitterClient *client = [TwitterClient instance];
        [client homeTimelineWithSuccess:^ (AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"tweets table view controller");
            //NSLog(@"response: %@", responseObject);
            self.tweetsArray = responseObject;
            //NSLog(@"array count: %d", [self.tweetsArray count]);
            //NSLog(@"%@", self.tweetsArray[1]);
            [self.displayView reloadData];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"response error: %@", error);
        }];
        
    }
    return self;
}
- (void)addNewTweetButton
{

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(65,20,200,40)];
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
    // Do any additional setup after loading the view from its nib.
        [self addNewTweetButton];
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
    
   /* self.yelpModel = [MTLJSONAdapter modelOfClass:YelpModel.class fromJSONDictionary:self.businesses[indexPath.row] error:NULL];
    
    DisplayCell *displayCell = [tableView dequeueReusableCellWithIdentifier:@"DisplayCell"];
    
    displayCell.nameLabel.text = [NSString stringWithFormat:@"%@. %@", index, self.yelpModel.name];
    
    displayCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", self.yelpModel.address, self.yelpModel.neighborhood];
    displayCell.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews",self.yelpModel.reviewCount];
    displayCell.categoryLabel.text = self.yelpModel.category;
    //displayCell.mileLabel.text = @"1.0";
    
    //Asynchronously load the image
    NSURL   *imageURL   = [NSURL URLWithString:self.yelpModel.imageURL];
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
    
    NSURL   *ratingsURL   = [NSURL URLWithString:self.yelpModel.ratingImageURL];
    NSURLRequest *requestRatingImage = [NSURLRequest requestWithURL:ratingsURL];
    
    //__weak UITableViewCell *weakCellRating = displayCell;
    
    
    [displayCell.ratingView setImageWithURLRequest:requestRatingImage
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               displayCell.ratingView.image = image;
                                               //weakCellRating.imageView.image = image;
                                               
                                               [displayCell setNeedsLayout];
                                               
                                           } failure:nil];
    
    
    return displayCell; */
}

@end
