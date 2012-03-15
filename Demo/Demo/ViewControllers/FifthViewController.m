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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.customTbBarController.tabBar.tabBarStyle = CMTabBarStyleDefault;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
