//
//  CMTabBar.h
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMTabBar : UIView

@property (nonatomic, assign) id<UITabBarDelegate>  delegate;
@property (nonatomic, assign) UITabBarItem*         selectedItem;

- (void)setItems:(NSArray*)tabBarItems animated:(BOOL)animated;

@property (nonatomic, retain) UIColor*              tintColor;
@property (nonatomic, retain) UIImage*              backgroundImage;
@property (nonatomic, retain) UIImage*              selectionIndicatorImage; 

@end
