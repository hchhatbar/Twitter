//
//  ContainerViewController.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/29/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "ContainerViewController.h"
#import "TwitterClient.h"
#import "LoginViewController.h"

#define kMargin 36

@interface ContainerViewController ()

@property(strong, nonatomic)  NSMutableArray    *viewControllers;

@property (strong, nonatomic) UIViewController *tvc;
@property (strong, nonatomic) UIViewController *mvc;
@property (strong, nonatomic) UIViewController *mentionsVC;
@property (strong, nonatomic) UIViewController *timeLineVC;
@property (strong, nonatomic) UINavigationController *navBar;
- (IBAction)onPan:(UIPanGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) UIView *childView;
@property (weak, nonatomic) IBOutlet UIView *menuVIew;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property TwitterClient *client;



@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
                self.client = [TwitterClient instance];
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"LoadMentions"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"LoadTimeLine"
                                                   object:nil];
        self.viewControllers = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"LoadProfile"
                                                   object:nil];
        self.viewControllers = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"LogOut"
                                                   object:nil];
        self.viewControllers = [[NSMutableArray alloc] init];
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"content v c");
    
    
    
    self.tvc = self.viewControllers[1];
    self.mvc = self.viewControllers[2];
    self.mentionsVC = self.viewControllers[3];
    self.timeLineVC = self.viewControllers[0];
    self.navBar = self.viewControllers[4];
    
    
    /*UIView *firstView = self.tvc.view;
    firstView.frame = self.containerView.frame;
    
    UIView *secondView = self.mvc.view;
    secondView.frame = self.containerView.frame;
    
    UIView *mentionsView = self.mentionsVC.view;
    mentionsView.frame = self.containerView.frame;
    
    UIView *profileView = self.timeLineVC.view;
    profileView.frame = self.containerView.frame;*/
    
    
    //[self.containerView addSubview:profileView];
    //[self.containerView addSubview:mentionsView];

    //[self.containerView addSubview: secondView];
    //[self.containerView addSubview: firstView];
    
    
    //[self.containerView addSubview: navigationController.view];

    //[self.tvc didMoveToParentViewController:self];
    
    /*[self addChildViewController:self.mvc];
    [self.containerView addSubview: self.mvc.view];
    
    [self addChildViewController:self.navBar];
    [self.containerView addSubview:self.navBar.view];         //  2
    
    [self.navBar didMoveToParentViewController:self];
    [self.mvc didMoveToParentViewController:self];*/
    

    // Add the initial ContentController (this is the timeline controller with navigation controller
   /* [self addChildViewController:self.navBar];
    self.navBar.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.navBar.view];
    [self.navBar didMoveToParentViewController:self];

    // Add sidebar Menu controller
    [self addChildViewController:self.mvc];
    self.mvc.view.frame = self.menuVIew.frame;
    [self.menuVIew addSubview:self.mvc.view];
    [self.mvc didMoveToParentViewController:self]; */
    
    [self addChildViewController:self.navBar];
     self.navBar.view.frame = self.menuVIew.frame;
     [self.menuVIew addSubview:self.navBar.view];
     [self.navBar didMoveToParentViewController:self];
     
     // Add sidebar Menu controller
     [self addChildViewController:self.mvc];
     self.mvc.view.frame = self.contentView.frame;
     [self.contentView addSubview:self.mvc.view];
     [self.mvc didMoveToParentViewController:self];
    

    [self addNewTweetButton];

   //[self.containerView didMoveToParentViewController:self]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addViewController:(UIViewController *) vc {
    
    [self.viewControllers addObject:vc];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"LoadMentions"])
    {
        
        [self.tvc.view addSubview:self.mentionsVC.view];
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //if (velocity.x >= -10) {
            self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);            //}
        } completion:nil];
        

        
   
    }
    
    if ([[notification name] isEqualToString:@"LoadTimeLine"])
    {
        [self.mentionsVC.view removeFromSuperview];
        [self.timeLineVC.view removeFromSuperview];
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //if (velocity.x >= -10) {
            self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);            //}
        } completion:nil];
        
    }

    
    if ([[notification name] isEqualToString:@"LoadProfile"])
    {
       [self.tvc.view addSubview:self.timeLineVC.view];
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //if (velocity.x >= -10) {
            self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);            //}
        } completion:nil];
        
    }
    
    if ([[notification name] isEqualToString:@"LogOut"])
    {
        [self.client deauthorize];
        LoginViewController *viewController = [[LoginViewController alloc] init];
       
        [self addChildViewController:viewController];
        //[self.contentView addSubview:viewController.view];
        //self.navBar.view.frame = self.menuVIew.frame;
        [self.menuVIew addSubview:viewController.view];
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //if (velocity.x >= -10) {
            self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);            //}
        } completion:nil];
        
    }

}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    //NSLog(@"on pan.....");
    self.childView = self.menuVIew;
    
    CGPoint velocity = [sender velocityInView:self.view];
    
    CGPoint translate = [sender translationInView:self.view];
    CGRect newFrame = self.childView.frame;
    newFrame.origin.x += translate.x;
    newFrame.origin.y += translate.y;
    
    //self.touched.frame = newFrame;
    if (sender.state == UIGestureRecognizerStateBegan ) {
        CGPoint transition = [sender locationInView:self.view];
        transition.y = 0;
        self.childView.frame = CGRectMake(transition.x, 0, self.childView.frame.size.width, self.childView.frame.size.height);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        
        //childView.frame = CGRectMake(childView.frame.size.width-kSlideMargin, 0, childView.frame.size.width, childView.frame.size.height);
        if (velocity.x >= 20) {
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
                if (velocity.x >= 20) {
                    //view.center = leftPoint;
                    self.childView.frame = CGRectMake(self.childView.frame.size.width-kMargin, 0, self.childView.frame.size.width, self.childView.frame.size.height);
                    
                }
            } completion:nil];
        } else {
            NSLog(@"velocity %f", velocity.x);
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //if (velocity.x >= -10) {
                self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
                //}
            } completion:nil];
        }
    }
}
@end
