//
//  AppDelegate.m
//  Twitter
//
//  Created by Hemen Chhatbar on 6/22/14.
//  Copyright (c) 2014 Hemen Chhatbar. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"
#import "ContainerViewController.h"
#import "TimeLineViewController.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    self.window.rootViewController = [[LoginViewController alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"cptwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]){
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"access token");
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    //[client homeTimelineWithSuccess:^ (AFHTTPRequestOperation *operation, id responseObject){
                    //    NSLog(@"response: %@", responseObject);
                    ContainerViewController *containerViewController = [[ContainerViewController alloc] init];
                    MenuViewController *menuViewController = [[MenuViewController alloc] init];
                    
                    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
                    tweetsViewController.testProp = @"hometimeline";
                    
                    TweetsViewController *mentionsViewController = [[TweetsViewController alloc] init];
                    
                    TimeLineViewController *timeLineViewController = [[TimeLineViewController alloc] init];
                   
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
                    UIColor *color = [self getUIColorObjectFromHexString:@"4099FF" alpha:.9];
                    navigationController.navigationBar.barTintColor = color;
                    
                    [containerViewController addViewController:timeLineViewController];
                    [containerViewController addViewController:tweetsViewController];
                    [containerViewController addViewController:menuViewController];
                    [containerViewController addViewController:mentionsViewController];
                    [containerViewController addViewController:navigationController];
                    
                    self.window.rootViewController = containerViewController; //navigationController;
                    
                    //self.window
                    
                    //} failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    //    NSLog(@"response error: %@", error);
                    //}];
                     
                    
                    
                    } failure:^(NSError *error) {
                    NSLog(@"no token");
                }];
                           }
        }
        return YES;
    }
    return NO;
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


@end
