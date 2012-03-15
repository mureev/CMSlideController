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

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    CMTabBarController* tabBarController = [[CMTabBarController new] autorelease];
    
    UIViewController* vc1 = [[UIViewController new] autorelease];
    vc1.title = @"1";
    vc1.tabBarItem.image = [UIImage imageNamed:@"22-skull-n-bones.png"];
    
    UIViewController* vc2 = [[UIViewController new] autorelease];
    vc2.title = @"2";
    vc2.tabBarItem.image = [UIImage imageNamed:@"23-bird.png"];
    
    UIViewController* vc3 = [[UIViewController new] autorelease];
    vc3.title = @"3";
    vc3.tabBarItem.image = [UIImage imageNamed:@"133-ufo.png"];
    
    UIViewController* vc4 = [[UIViewController new] autorelease];
    vc4.title = @"4";
    vc4.tabBarItem.image = [UIImage imageNamed:@"164-glasses-2.png"];
    
    UIViewController* vc5 = [[UIViewController new] autorelease];
    vc5.title = @"5";
    vc5.tabBarItem.image = [UIImage imageNamed:@"196-radiation.png"];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, nil];
    tabBarController.view.backgroundColor = [UIColor clearColor];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
