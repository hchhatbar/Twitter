//
//  MenuViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/29/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "MenuViewController.h"
#import "TwitterClient.h"
#import "LoginViewController.h"

@interface MenuViewController ()
- (IBAction)mentionsClick:(id)sender;
- (IBAction)timeLineClick:(id)sender;
- (IBAction)profileClick:(id)sender;
- (IBAction)logOutClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;

@property TwitterClient *client;
@property (nonatomic,strong) NSMutableDictionary *tweetsArray;

@end

@implementation MenuViewController

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
    NSLog(@"MENU VIEW DID LOAD......");
    [self.client verifyCredentials:^ (AFHTTPRequestOperation *operation, id responseObject){
        
        //NSLog(@"response: %@", responseObject);
        self.tweetsArray = responseObject;
        
        NSLog(@" %@", self.tweetsArray[@"name"]);
        NSLog(@" %@", self.tweetsArray[@"screen_name"]);
        self.displayNameLabel.text = self.tweetsArray[@"name"];
        self.nameLabel.text = self.tweetsArray[@"screen_name"];
        
        NSString *url = [self.tweetsArray[@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        self.thumbView.image =[UIImage imageWithData:imageData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)mentionsClick:(id)sender {
    
    NSLog(@"mentions");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LoadMentions"
     object:self];

}

- (IBAction)timeLineClick:(id)sender {
       NSLog(@"timeline");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LoadTimeLine"
     object:self];

    
}

- (IBAction)profileClick:(id)sender {
    
       NSLog(@"profile");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LoadProfile"
     object:self];

}

- (IBAction)logOutClick:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LogOut"
     object:self];

    
        
    
}
@end
