//
//  CMTabBarController.h
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMTabBar.h"

@interface CMTabBarController : UIViewController <CMTabBarDelegate>

+ (id)sharedTabBarController;

@property (nonatomic, retain) NSArray*              viewControllers;

@property (nonatomic, readonly) UIViewController*   selectedViewController;
@property (nonatomic, assign) NSUInteger            selectedIndex;

@property (nonatomic, retain) CMTabBar*             tabBar;

@property (nonatomic, assign) id<UITabBarControllerDelegate> delegate;

@end
