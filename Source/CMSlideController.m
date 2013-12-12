//
//  CMSlideController.m
//
//  Created by Constantine Mureev on 11/12/13.
//  Copyright (c) 2013 Constantine Mureev. All rights reserved.
//

#import "CMSlideController.h"

@interface CMSlideController ()

@property (nonatomic, readwrite) UIViewController *menuViewController;
@property (nonatomic, readwrite) UIViewController *contentViewController;

@end

@implementation CMSlideController

- (id)initWithMenuController:(UIViewController *)menuViewController contentController:(UIViewController *)contentViewController {
    self = [super init];
    if (self) {
        self.scale = 0.475f;
        
        self.backgoundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.backgoundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.menuViewController = menuViewController;
        self.contentViewController = contentViewController;
        
        // Do View Controller child/parent relationship stuff
        
        [self.menuViewController willMoveToParentViewController:self];
        [self.contentViewController willMoveToParentViewController:self];
        [self addChildViewController:self.menuViewController];
        [self addChildViewController:self.contentViewController];
        [self.menuViewController didMoveToParentViewController:self];
        [self.contentViewController didMoveToParentViewController:self];
        
        // Prepeare
        
        self.menuViewController.view.transform = [self scaleUpTransform:self.menuViewController.view.transform];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgoundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.backgoundImageView];
    [self.view addSubview:self.menuViewController.view];
    [self.view addSubview:self.contentViewController.view];
}

- (void)openMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewController.view.transform = [self scaleDownTransform:self.contentViewController.view.transform];
        self.menuViewController.view.transform = [self scaleDownTransform:self.menuViewController.view.transform];
    } completion:^(BOOL finished) {
        if (completion) {
            completion (finished);
        }
    }];
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewController.view.transform = [self scaleUpTransform:self.contentViewController.view.transform];
        self.menuViewController.view.transform = [self scaleUpTransform:self.menuViewController.view.transform];
    } completion:^(BOOL finished) {
        if (completion) {
            completion (finished);
        }
    }];
}

- (void)pushContentController:(UIViewController *)contentViewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    UIViewController *prevViewController = self.contentViewController;
    self.contentViewController = contentViewController;
    
    [self.contentViewController willMoveToParentViewController:self];
    [self addChildViewController:self.contentViewController];
    
    self.contentViewController.view.alpha = 0;
    self.contentViewController.view.transform = prevViewController.view.transform;
    
    [self transitionFromViewController:prevViewController toViewController:self.contentViewController duration:0.3 options:0 animations:^{
        prevViewController.view.alpha = 0;
        self.contentViewController.view.alpha = 1;
        prevViewController.view.transform = [self scaleUpTransform:prevViewController.view.transform];
        self.contentViewController.view.transform = [self scaleUpTransform:self.contentViewController.view.transform];
        self.menuViewController.view.transform = [self scaleUpTransform:self.menuViewController.view.transform];
    } completion:^(BOOL finished) {
        prevViewController.view.alpha = 1;
        
        [self.contentViewController didMoveToParentViewController:self];
        [prevViewController removeFromParentViewController];
        
        if (completion) {
            completion (finished); 
        }
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Transform animations


- (CGAffineTransform)scaleUpTransform:(CGAffineTransform)transform {
    CGAffineTransform result = CGAffineTransformScale(transform, 1.0 / self.scale, 1.0 / self.scale);
    return result;
}

- (CGAffineTransform)scaleDownTransform:(CGAffineTransform)transform {
    CGAffineTransform result = CGAffineTransformScale(transform, self.scale, self.scale);
    return result;
}

@end
