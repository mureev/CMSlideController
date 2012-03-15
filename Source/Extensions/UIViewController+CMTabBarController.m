//
//  UIViewController+CMTabBarController.m
//
//  Created by Constantine Mureev on 3/15/12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "UIViewController+CMTabBarController.h"

@implementation UIViewController (CMTabBarController)

@dynamic customTbBarController;

- (CMTabBarController*)customTbBarController {
    return [CMTabBarController sharedTabBarController];
}

@end
