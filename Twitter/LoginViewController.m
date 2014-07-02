//
//  LoginViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

- (IBAction)onLoginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        //self.twitterImageView.center = CGPointMake(self.twitterImageView.ce,
        //self.twitterImageView.transform = CGAffineTransformMakeScale(2,2);
        self.twitterImageView.center = CGPointMake(self.twitterImageView.center.x + 150, self.twitterImageView.center.y - 250);
        
    } completion:^(BOOL finished) {
        [[TwitterClient instance] login];

    }];
     
}
@end
