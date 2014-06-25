//
//  ComposeTweetViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/23/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface ComposeTweetViewController ()
@property TwitterClient *client;
@property (nonatomic,strong) NSMutableDictionary *tweetsArray;

@end

@implementation ComposeTweetViewController

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
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTintColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 4.0f;
    [self.navigationController.view addSubview:button];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setFrame:CGRectMake(250,20,60,40)];
    [searchButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor redColor]];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(tweetClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    searchButton.layer.borderColor = [UIColor clearColor].CGColor;
    searchButton.layer.borderWidth = 1.0f;
    searchButton.layer.cornerRadius = 4.0f;
    [self.navigationController.view addSubview:searchButton];
    
    
}

- (void)cancelClickEvent: (id) sender {
    NSLog(@"%@", @"Cancel Pressed");
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)tweetClickEvent: (id) sender {
    
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    NSLog(@" %@",self.tweetTextView.text);
    TwitterClient *client = [TwitterClient instance];
    [client updateStatus:self.tweetTextView.text  success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
        self.tweetTextView.text = @"Error posting the tweet";
    }];
    
    

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.client verifyCredentials:^ (AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        self.tweetsArray = responseObject;
        
        NSLog(@" %@", self.tweetsArray[@"name"]);
                NSLog(@" %@", self.tweetsArray[@"screen_name"]);
        self.displayNameLabel.text = self.tweetsArray[@"name"];
        self.nameLabel.text = self.tweetsArray[@"screen_name"];
            
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.tweetsArray[@"profile_image_url"]]];
        self.thumbView.image =[UIImage imageWithData:imageData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];
    

    [self addCancelAndTweetButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
