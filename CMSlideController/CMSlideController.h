//
//  CMSlideController.h
//
//  Created by Constantine Mureev on 11/12/13.
//  Copyright (c) 2013 Constantine Mureev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSlideController : UIViewController

@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isMenuOpen) BOOL menuOpen;

@property (nonatomic) CGFloat scale;
@property (nonatomic) UIImageView *backgoundImageView;

@property (nonatomic, readonly) UIViewController *menuViewController;
@property (nonatomic, readonly) UIViewController *contentViewController;

- (id)initWithMenuController:(UIViewController *)menuViewController
           contentController:(UIViewController *)contentViewController;

- (void)openMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)pushContentController:(UIViewController *)contentViewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
