//
//  CMSlideController.m
//
//  Created by Constantine Mureev on 11/12/13.
//  Copyright (c) 2013 Constantine Mureev. All rights reserved.
//

#import "CMSlideController.h"

@interface CMSlideController ()

@property (nonatomic) BOOL  menuOpen;
@property (nonatomic) UIButton *closeOverlayButton;
@property (nonatomic, readwrite) UIViewController *menuViewController;
@property (nonatomic, readwrite) UIViewController *prevContentViewController;
@property (nonatomic, readwrite) UIViewController *contentViewController;

@end

@implementation CMSlideController

- (id)initWithMenuController:(UIViewController *)menuViewController contentController:(UIViewController *)contentViewController {
    self = [super init];
    if (self) {
        self.scale = 0.5634f;
        self.menuOpen = NO;
        
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
        
        if ([menuViewController.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)menuViewController.view;
            scrollView.scrollsToTop = NO;
        }
        
        menuViewController.view.clipsToBounds = NO;
        
        [self applyShadowToViewController:self.contentViewController];
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
    if (!self.menuOpen) {
        self.menuOpen = YES;
        
        [self animateMenuOpenWithDuration:animated ? 0.3: 0 completion:^(BOOL finished) {
            [self applyOverlayButtonToMainViewController];

            if (completion) {
                completion(finished);
            }
        }];
    } else if (completion) {
        completion(YES);
    }
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (self.menuOpen) {
        self.menuOpen = NO;
        
        [self.closeOverlayButton removeFromSuperview];
        self.closeOverlayButton = nil;
        
        [self animateMenuCloseWithDuration:animated ? 0.3: 0 completion:completion];
    } else if (completion) {
        completion(YES);
    }
}

- (void)pushContentController:(UIViewController *)contentViewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (self.contentViewController != contentViewController) {
        self.prevContentViewController = self.contentViewController;
        self.contentViewController = contentViewController;
        
        [self.contentViewController willMoveToParentViewController:self];
        [self applyShadowToViewController:self.contentViewController];
        [self addChildViewController:self.contentViewController];
        
        // Do it always animated
        
        [self transitionFromViewController:self.prevContentViewController toViewController:self.contentViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            [self.contentViewController didMoveToParentViewController:self];
            [self.prevContentViewController removeFromParentViewController];
            self.prevContentViewController = nil;
        }];
        
        if (self.menuOpen) {
            self.contentViewController.view.transform = self.prevContentViewController.view.transform;
            [self closeMenuAnimated:animated completion:completion];
        } else {
            self.contentViewController.view.transform = self.prevContentViewController.view.transform;
        }
    } else {
        [self closeMenuAnimated:animated completion:completion];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Animate transitions


- (void)animateMenuOpenWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:^{
        self.contentViewController.view.transform = [self scaleDownTransform:self.contentViewController.view.transform];
        self.menuViewController.view.transform = [self scaleDownTransform:self.menuViewController.view.transform];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)animateMenuCloseWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:^{
        self.contentViewController.view.transform = [self scaleUpTransform:self.contentViewController.view.transform];
        self.menuViewController.view.transform = [self scaleUpTransform:self.menuViewController.view.transform];
        self.prevContentViewController.view.transform = [self scaleUpTransform:self.prevContentViewController.view.transform];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}


#pragma mark - Transform animations


- (CGAffineTransform)scaleUpTransform:(CGAffineTransform)transform {
    CGAffineTransform result = CGAffineTransformScale(transform, 1.0 / self.scale, 1.0 / self.scale);
    return CGAffineTransformMake(result.a, result.b, result.c, result.d, result.tx - 180, 0);
}

- (CGAffineTransform)scaleDownTransform:(CGAffineTransform)transform {
    CGAffineTransform result = CGAffineTransformScale(transform, self.scale, self.scale);
    return CGAffineTransformMake(result.a, result.b, result.c, result.d, result.tx + 180, 0);
}


#pragma mark - Overlay


- (void)applyShadowToViewController:(UIViewController *)viewController {
    CALayer *mainLayer = viewController.view.layer;
    if (mainLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:mainLayer.bounds];
        mainLayer.shadowPath = path.CGPath;
        mainLayer.shadowColor = [UIColor blackColor].CGColor;
        mainLayer.shadowOffset = CGSizeZero;
        mainLayer.shadowOpacity = 0.6f;
        mainLayer.shadowRadius = 10.0f;
    }
}

- (void)applyOverlayButtonToMainViewController {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.opaque = NO;
    button.frame = self.contentViewController.view.frame;
    
    [button addTarget:self action:@selector(closeButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(closeButtonTouchedDown) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(closeButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view addSubview:button];
    self.closeOverlayButton = button;
}

- (void)closeButtonTouchUpInside {
    [self closeMenuAnimated:YES completion:nil];
}

- (void)closeButtonTouchedDown {
    [UIView animateWithDuration:0.1 animations:^{
        self.closeOverlayButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}

- (void)closeButtonTouchUpOutside {
    [UIView animateWithDuration:0.1 animations:^{
        self.closeOverlayButton.backgroundColor = [UIColor clearColor];
    }];
}

@end
