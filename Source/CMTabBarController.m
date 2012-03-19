//
//  CMTabBarController.m
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBarController.h"

#import "CMTabBarUtils.h"


@interface CMTabBarController ()

@property (assign) BOOL         firstAppear;

- (CGRect)frameForViewControllers;

@end


@implementation CMTabBarController

@synthesize firstAppear;
@synthesize viewControllers, selectedIndex, tabBar=_tabBar, delegate;
@dynamic selectedViewController;

static CMTabBarController* sharedInstance = nil;

+ (id)sharedTabBarController {
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        sharedInstance = self;
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
    
    self.firstAppear = YES;
    
    for (UIViewController* vc in self.viewControllers) {
        [vc loadView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (firstAppear) {
        // Custom logic
        NSMutableArray* tabBarItems = [NSMutableArray array];
        CGRect newFrame = [self frameForViewControllers];
        
        for (UIViewController* vc in self.viewControllers) {
            [tabBarItems addObject:vc.tabBarItem];
            
            // Update frame to real size ()
            vc.view.frame = newFrame;
        }
        [self.tabBar setItems:tabBarItems animated:NO];
        
        [self.view addSubview:self.selectedViewController.view];        
        [self.view bringSubviewToFront:self.tabBar];
        
        self.firstAppear = NO;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [self.selectedViewController viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [self.selectedViewController viewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [self.selectedViewController viewWillDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [self.selectedViewController viewDidDisappear:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIViewController* vc in self.viewControllers) {
        [vc viewDidLoad];
    }
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


#pragma mark - Private


- (CGRect)frameForViewControllers {
    CGFloat height = self.view.bounds.size.height;
    
    if (self.tabBar.tabBarStyle == CMTabBarStyleDefault) {
        height -= self.tabBar.bounds.size.height;
    }
    
    return CGRectMake(0, 0, self.view.bounds.size.width, height);
}


#pragma mark - UITabBarDelegate


- (void)tabBar:(id)tabBar willSelectItemAtIndex:(NSUInteger)index currentIndex:(NSUInteger)currentIndex {
    UIViewController* willSelectViewController = (UIViewController*)[self.viewControllers objectAtIndex:index];
    CGRect frame = [self frameForViewControllers];
    if (!CGRectEqualToRect(frame, willSelectViewController.view.frame)) {
        willSelectViewController.view.frame = frame;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [self.selectedViewController viewWillDisappear:NO];
        [willSelectViewController viewWillAppear:NO];
    }
}

- (void)tabBar:(id)tabBar didSelectItemAtIndex:(NSUInteger)index prviousIndex:(NSUInteger)prviousIndex {
    UIViewController* currentViewController = (UIViewController*)[self.viewControllers objectAtIndex:prviousIndex];
    [currentViewController.view removeFromSuperview];
    
    [self.view addSubview:self.selectedViewController.view];        
    [self.view bringSubviewToFront:self.tabBar];
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [currentViewController viewDidDisappear:NO];
        [self.selectedViewController viewDidAppear:NO];
    }
}

- (void)tabBar:(id)tabBar willChangeTabBarStyle:(CMTabBarStyle)tabBarStyle {
}

- (void)tabBar:(id)tabBar didChangeTabBarStyle:(CMTabBarStyle)tabBarStyle {
    CGRect newFrame = [self frameForViewControllers];
    for (UIViewController* vc in self.viewControllers) {
        vc.view.frame = newFrame;
    }    
}

@end
