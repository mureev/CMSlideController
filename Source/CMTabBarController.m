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

@synthesize viewControllers, selectedIndex, tabBar=_tabBar, delegate;
@dynamic selectedViewController;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.viewControllers = nil;
    self.tabBar.delegate = nil;
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
    self.tabBar.delegate = self;
    
    
    for (UIViewController* vc in self.viewControllers) {
        [vc loadView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.selectedViewController viewWillDisappear:animated];
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
        vc.view.hidden = YES;
        [self.view addSubview:vc.view];
    }
    [self.tabBar setItems:tabBarItems animated:NO];
    self.selectedViewController.view.hidden = NO;
    [self.view bringSubviewToFront:self.tabBar];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    for (UIViewController* vc in self.viewControllers) {
        [vc viewDidUnload];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    for (UIViewController* vc in self.viewControllers) {
        [vc shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController* vc in self.viewControllers) {
        [vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for (UIViewController* vc in self.viewControllers) {
        [vc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController* vc in self.viewControllers) {
        [vc willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (UIViewController*)selectedViewController {
    return [self.viewControllers objectAtIndex:self.tabBar.selectedIndex];
}


#pragma mark - UITabBarDelegate


- (void)tabBar:(id)tabBar willSelectItemAtIndex:(NSUInteger)index {
    [self.selectedViewController viewWillDisappear:NO];
}

- (void)tabBar:(id)tabBar didSelectItemAtIndex:(NSUInteger)index {
    for (UIViewController* vc in self.viewControllers) {
        vc.view.hidden = YES;
    }
    
    self.selectedViewController.view.hidden = NO;
    
    [self.selectedViewController viewWillAppear:NO];
}


@end
