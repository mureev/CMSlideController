//
//  CMTabBar.m
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBar.h"


@interface CMTabBar()

@property (nonatomic, retain) NSArray*      items;
@property (nonatomic, retain) UIImageView*  backgroundImageView;

- (UIImage*)defaultBackgroundImage;

@end


@implementation CMTabBar

@synthesize delegate, items, selectedItem, tintColor, backgroundImage, selectionIndicatorImage;
@synthesize backgroundImageView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundImage = [self defaultBackgroundImage];
        
        self.backgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
        self.backgroundImageView.image = [self defaultBackgroundImage];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backgroundImageView];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark - Public


- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    // Add KVO for each UITabBarItem
}


#pragma mark - Private


- (UIImage*)defaultBackgroundImage {
    CGFloat width = 2048;
    // Get the image that will form the top of the background
    UIImage* topImage = [UIImage imageNamed:@"tabBarGradient.png"];
    
    // Create a new image context
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2 + 5), NO, 0.0);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, self.frame.size.height), NO, 0.0);
    
    // Create a stretchable image for the top of the background and draw it
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    //[stretchedTopImage drawInRect:CGRectMake(0, 5, width, topImage.size.height)];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
    //[[UIColor blackColor] set];
    //CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height + 5, width, topImage.size.height));
    //CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height + 0, width, topImage.size.height));
    
    // clear background for arrow image;
    //UIImage* arrow = [self tabBarArrowImage];
    //CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(width/2, 5, arrow.size.width, 2));
    
    // set this positions to tabbar
    //[self.tabBar addArrowAt:CGRectMake(width/2, 0, arrow.size.width, arrow.size.height)];
    //[self.tabBarArrowImage drawInRect:CGRectMake(width/2, 0, arrow.size.width, arrow.size.height)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


@end
