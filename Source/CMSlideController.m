//
//  CMSlideController.m
//
//  Created by Constantine Mureev on 11/12/13.
//  Copyright (c) 2013 Constantine Mureev. All rights reserved.
//

#import "CMSlideController.h"

typedef NS_ENUM(NSUInteger, CMSlideControllerState) {
    CMSlideControllerStateNormal = 0,
    CMSlideControllerStateMinimized,
    CMSlideControllerStateMaximized
};

@interface CMSlideController () <UIGestureRecognizerDelegate>

@property (nonatomic, readwrite, getter = isDragging) BOOL dragging;
@property (nonatomic, readwrite, getter = isMenuOpen) BOOL menuOpen;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIButton *closeOverlayButton;

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
            UIScrollView *scrollView = (UIScrollView *) menuViewController.view;
            scrollView.scrollsToTop = NO;
        }

        menuViewController.view.clipsToBounds = NO;

        [self applyGestureRecognizerToViewController:self.contentViewController];
        [self applyShadowToViewController:self.contentViewController];
        self.menuViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateNormal toState:CMSlideControllerStateMaximized progress:1];
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
    [self openMenuWithDuration:animated ? 0.3 : 0 completion:completion];
}

- (void)openMenuWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    self.menuOpen = YES;

    [self animateMenuOpenWithDuration:duration completion:^(BOOL finished) {
        [self applyOverlayButtonToMainViewController];

        if (completion) {
            completion(finished);
        }
    }];
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self closeMenuWithDuration:animated ? 0.3 : 0 completion:completion];
}

- (void)closeMenuWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    self.menuOpen = NO;

    [self.closeOverlayButton removeFromSuperview];
    self.closeOverlayButton = nil;

    [self animateMenuCloseWithDuration:duration completion:completion];
}

- (void)pushContentController:(UIViewController *)contentViewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (self.contentViewController != contentViewController) {
        self.prevContentViewController = self.contentViewController;
        self.contentViewController = contentViewController;

        [self.contentViewController willMoveToParentViewController:self];

        [self.prevContentViewController.view removeGestureRecognizer:self.panGestureRecognizer];
        [self applyGestureRecognizerToViewController:self.contentViewController];
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
        self.contentViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateNormal toState:CMSlideControllerStateMinimized progress:1];
        self.menuViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateMaximized toState:CMSlideControllerStateNormal progress:1];
    }                completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)animateMenuCloseWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:^{
        self.contentViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateMinimized toState:CMSlideControllerStateNormal progress:1];
        self.menuViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateNormal toState:CMSlideControllerStateMaximized progress:1];
        self.prevContentViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateMinimized toState:CMSlideControllerStateNormal progress:1];
    }                completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}


#pragma mark - Transform animations


- (CGAffineTransform)scaleTransformFromState:(CMSlideControllerState)from toState:(CMSlideControllerState)to progress:(float)progress {
    // asserts

    CGAffineTransform result;
    if (from == CMSlideControllerStateNormal && to == CMSlideControllerStateMaximized) {
        CGFloat scaledValue = 1 / self.scale * progress;
        result = CGAffineTransformMake(scaledValue, 0, 0, scaledValue, -(progress * 180), 0);
    } else if (from == CMSlideControllerStateNormal && to == CMSlideControllerStateMinimized) {
        CGFloat scaledValue = 1 - (1 - self.scale) * progress;
        result = CGAffineTransformMake(scaledValue, 0, 0, scaledValue, progress * 180, 0);
    } else if (from == CMSlideControllerStateMaximized && to == CMSlideControllerStateNormal) {
        CGFloat scaledValue = 1 / self.scale - ((1 / self.scale) - 1) * progress;
        result = CGAffineTransformMake(scaledValue, 0, 0, scaledValue, -180 + (progress * 180), 0);
    } else if (to == CMSlideControllerStateNormal) {
        // Ignore progress in other cases
        result = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    } else {
        // Exception;
    }

    return result;
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

- (void)applyGestureRecognizerToViewController:(UIViewController *)viewController {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [viewController.view addGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer.delegate = self;
}

- (void)applyOverlayButtonToMainViewController {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.opaque = NO;
    button.frame = self.contentViewController.view.frame;
    
    [button addTarget:self action:@selector(closeButtonAction) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchDragOutside)];
    
    [button addTarget:self action:@selector(closeButtonTouchedDown) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(closeButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view addSubview:button];
    self.closeOverlayButton = button;
}

- (void)closeButtonAction {
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

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity width:(CGFloat)width {
    NSTimeInterval durationLowLimit = 0.25;
    NSTimeInterval durationHightLimit = 0.05;

    NSTimeInterval animationDurationDiff = durationHightLimit - durationLowLimit;
    CGFloat horizontalVelocity = velocity.x;

    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;

    return (durationHightLimit + durationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}


#pragma mark - Handle Gestures


- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    UIView *gestureView = self.contentViewController.view;
    UIGestureRecognizerState state = gesture.state;
    CGPoint translation = [gesture translationInView:gestureView];
    CGPoint velocity = [gesture velocityInView:gestureView];

    CGFloat percentage = MIN(1, translation.x / (320.0f * 1.1));
    percentage = MAX(0, percentage);

    self.menuOpen = percentage > 0;

    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        self.dragging = YES;

        self.contentViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateNormal toState:CMSlideControllerStateMinimized progress:percentage];
        self.menuViewController.view.transform = [self scaleTransformFromState:CMSlideControllerStateMaximized toState:CMSlideControllerStateNormal progress:percentage];
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        self.dragging = NO;

        NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity width:CGRectGetWidth(gestureView.frame)];

        if (percentage > 0.25) {
            [self openMenuWithDuration:animationDuration completion:nil];
        } else {
            [self closeMenuWithDuration:animationDuration completion:nil];
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        UIPanGestureRecognizer *g = (UIPanGestureRecognizer *) gestureRecognizer;
        UIView *gestureView = self.contentViewController.view;
        CGPoint point = [g velocityInView:gestureView];

        if (fabsf(point.x) > fabsf(point.y)) {
            if (point.x < 0) {
                return NO;
            } else {
                return YES;
            }
        }
    }

    return NO;
}

@end
