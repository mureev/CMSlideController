//
//  CMTabBarUtils.h
//
//  Created by Constantine Mureev on 15.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMTabBarUtils : NSObject

+ (UIImage*)tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource;
+ (UIImage*)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backImage;
+ (UIImage*)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage;

@end
