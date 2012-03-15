//
//  AppDelegate.m
//  Demo CMTabBarController
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "CMTabBarController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    CMTabBarController* tabBarController = [[CMTabBarController new] autorelease];
    
    FirstViewController* vc1 = [[FirstViewController new] autorelease];    
    SecondViewController* vc2 = [[SecondViewController new] autorelease];    
    ThirdViewController* vc3 = [[ThirdViewController new] autorelease];    
    FourthViewController* vc4 = [[FourthViewController new] autorelease];    
    FifthViewController* vc5 = [[FifthViewController new] autorelease];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, vc5, nil];
    tabBarController.view.backgroundColor = [UIColor clearColor];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
