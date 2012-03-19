//
//  CMTabBar.h
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    CMTabBarStyleDefault,
    CMTabBarStyleDefaultGloss,
    CMTabBarStyleTranslucent,
    CMTabBarStyleTranslucentGloss,
} CMTabBarStyle;


@protocol CMTabBarDelegate <NSObject>

- (void)tabBar:(id)tabBar willSelectItemAtIndex:(NSUInteger)index currentIndex:(NSUInteger)currentIndex;
- (void)tabBar:(id)tabBar didSelectItemAtIndex:(NSUInteger)index prviousIndex:(NSUInteger)prviousIndex;
- (void)tabBar:(id)tabBar willChangeTabBarStyle:(CMTabBarStyle)tabBarStyle;
- (void)tabBar:(id)tabBar didChangeTabBarStyle:(CMTabBarStyle)tabBarStyle;

@end


@interface CMTabBar : UIView

@property (nonatomic, assign) id<CMTabBarDelegate>  delegate;
@property (nonatomic, assign) NSUInteger            selectedIndex;

- (void)setItems:(NSArray*)tabBarItems animated:(BOOL)animated;

@property (nonatomic, assign) CMTabBarStyle         tabBarStyle;

@end
