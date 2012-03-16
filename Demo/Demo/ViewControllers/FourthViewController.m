//
//  FourthViewController.m
//  Demo CMTabBarController
//
//  Created by Constantine Mureev on 15.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "FourthViewController.h"
#import "UIViewController+CMTabBarController.h"


@interface FourthViewController ()

@end


@implementation FourthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"4";
    self.tabBarItem.image = [UIImage imageNamed:@"164-glasses-2.png"];
    
    NSLog(@"%@ - viewDidLoad", self.title);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@ - viewDidUnload", self.title);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.customTbBarController.tabBar.tabBarStyle = CMTabBarStyleTranslucent;
    
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
