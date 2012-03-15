//
//  CMTabBar.h
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMTabBarDelegate <NSObject>

- (void)tabBar:(id)tabBar didSelectItemAtIndex:(NSUInteger)index;

@end


@interface CMTabBar : UIView

@property (nonatomic, assign) id<CMTabBarDelegate>  delegate;
@property (nonatomic, assign) NSUInteger            selectedIndex;

- (void)setItems:(NSArray*)tabBarItems animated:(BOOL)animated;

@property (nonatomic, retain) UIColor*              tintColor;
@property (nonatomic, retain) UIImage*              backgroundImage;
@property (nonatomic, retain) UIImage*              selectionIndicatorImage; 

@end
