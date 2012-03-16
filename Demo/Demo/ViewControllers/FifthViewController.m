//
//  FifthViewController.m
//  Demo CMTabBarController
//
//  Created by Constantine Mureev on 15.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "FifthViewController.h"
#import "UIViewController+CMTabBarController.h"


@interface FifthViewController ()

@end


@implementation FifthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"5";
    self.tabBarItem.image = [UIImage imageNamed:@"196-radiation.png"];
    
    NSLog(@"%@ - viewDidLoad", self.title);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@ - viewDidUnload", self.title);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.customTbBarController.tabBar.tabBarStyle = CMTabBarStyleDefault;
    
    NSLog(@"%@ - viewWillAppear", self.title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%@ - viewDidAppear", self.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ - viewWillDisappear", self.title);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"%@ - viewDidDisappear", self.title);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
