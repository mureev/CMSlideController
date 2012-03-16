//
//  SecondViewController.m
//  Demo CMTabBarController
//
//  Created by Constantine Mureev on 15.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (retain) UILabel*     titleLabel;

@end

@implementation SecondViewController

@synthesize titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"2";
    self.tabBarItem.image = [UIImage imageNamed:@"23-bird.png"];
    
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowColor = [UIColor blackColor];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    
    NSString* frameString = [NSString stringWithFormat:@"%@ - frame {%.0f, %.0f, %.0f, %.0f}", self.title, self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height];
    NSLog(@"%@", frameString);
    self.titleLabel.text = frameString;
    
    [self.view addSubview:self.titleLabel];
    [self.view addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    
    NSLog(@"%@ - viewDidLoad", self.title);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@ - viewDidUnload", self.title);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        NSString* frameString = [NSString stringWithFormat:@"%@ - frame {%.0f, %.0f, %.0f, %.0f}", self.title, self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height];
        NSLog(@"%@", frameString);
        self.titleLabel.text = frameString;
    }
}

@end
