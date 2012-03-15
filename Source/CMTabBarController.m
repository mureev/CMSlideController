//
//  CMTabBarController.m
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBarController.h"

@interface CMTabBarController ()

@end

@implementation CMTabBarController

@synthesize viewControllers, selectedIndex, selectedViewController, tabBar=_tabBar, delegate; 

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.viewControllers = nil;
    self.selectedViewController = nil;
    self.tabBar = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGFloat tabBarHeight = 44.0f;
    self.tabBar = [[[CMTabBar alloc] initWithFrame:CGRectMake(0, frame.size.height - tabBarHeight, frame.size.width, tabBarHeight)] autorelease];
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.tabBar];
    
    
    for (UIViewController* vc in self.viewControllers) {
        [vc loadView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UIViewController* vc in self.viewControllers) {
        [vc viewWillAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (UIViewController* vc in self.viewControllers) {
        [vc viewWillDisappear:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIViewController* vc in self.viewControllers) {
        [vc viewDidLoad];
    }
    
    // Custom logic
    NSMutableArray* tabBarItems = [NSMutableArray array];
    for (UIViewController* vc in self.viewControllers) {
        [tabBarItems addObject:vc.tabBarItem];
    }
    [self.tabBar setItems:tabBarItems animated:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    for (UIViewController* vc in self.viewControllers) {
        [vc viewDidUnload];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
