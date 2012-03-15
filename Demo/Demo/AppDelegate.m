//
//  AppDelegate.m
//  Demo CMTabBarController
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "CMTabBarController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    CMTabBarController* tabBarController = [[CMTabBarController new] autorelease];
    
    UIViewController* vc1 = [[UIViewController new] autorelease];
    vc1.title = @"1";
    UIViewController* vc2 = [[UIViewController new] autorelease];
    vc2.title = @"2";
    UIViewController* vc3 = [[UIViewController new] autorelease];
    vc3.title = @"3";
    UIViewController* vc4 = [[UIViewController new] autorelease];
    vc4.title = @"4";
    UIViewController* vc5 = [[UIViewController new] autorelease];
    vc5.title = @"5";
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, nil];
    tabBarController.view.backgroundColor = [UIColor clearColor];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
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

@end
