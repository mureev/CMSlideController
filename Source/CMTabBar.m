//
//  CMTabBar.m
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBar.h"
#import "UIControl+Blocks.h"
#import "CMTabBarUtils.h"


@interface CMTabBar()

@property (nonatomic, assign) BOOL          useGlossEffect;
@property (nonatomic, retain) NSArray*      buttons;
@property (nonatomic, retain) UIImageView*  backgroundImageView;
@property (nonatomic, retain) UIImageView*  selectedImageView;

- (UIImage*)defaultBackgroundImage;
- (UIImage*)defaultSelectionIndicatorImage;

@end


@implementation CMTabBar

@synthesize delegate, selectedIndex=_selectedIndex, tabBarStyle=_tabBarStyle;
@synthesize useGlossEffect, buttons, backgroundImageView, selectedImageView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundImageView = [[[UIImageView alloc] initWithImage:[self defaultBackgroundImage]] autorelease];
        self.backgroundImageView.contentMode = UIViewContentModeBottom;
        self.backgroundImageView.center = CGPointMake(self.center.x, self.frame.size.height/2);
        self.backgroundImageView.backgroundColor = [UIColor clearColor];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.backgroundImageView];
        
        self.selectedImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)] autorelease];
        self.selectedImageView.image = [self defaultSelectionIndicatorImage];
        self.selectedImageView.contentMode = UIViewContentModeBottom;
        self.selectedImageView.backgroundColor = [UIColor clearColor];
        self.selectedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.selectedImageView];
        
        self.tabBarStyle = CMTabBarStyleDefault;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex != selectedIndex && selectedIndex < [self.buttons count]) {
        [self willChangeValueForKey:@"selectedIndex"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:willSelectItemAtIndex:currentIndex:)]) {
            [self.delegate tabBar:self willSelectItemAtIndex:selectedIndex currentIndex:_selectedIndex];
        }
        
        // check only for first selection
        if (_selectedIndex < [self.buttons count]) {
            UIButton* oldButton = [self.buttons objectAtIndex:_selectedIndex];
            [oldButton setImage:[oldButton imageForState:UIControlStateDisabled] forState:UIControlStateNormal];
        }
        
        UIButton* newButton = [self.buttons objectAtIndex:selectedIndex];
        [newButton setImage:[newButton imageForState:UIControlStateSelected] forState:UIControlStateNormal];
        
        self.selectedImageView.center = newButton.center;
        
        NSUInteger prviousIndex = _selectedIndex;
        _selectedIndex = selectedIndex;
        
        [self didChangeValueForKey:@"selectedIndex"];        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:prviousIndex:)]) {
            [self.delegate tabBar:self didSelectItemAtIndex:_selectedIndex prviousIndex:prviousIndex];
        }
    }
}

- (void)setTabBarStyle:(CMTabBarStyle)tabBarStyle {
    if (_tabBarStyle != tabBarStyle) {
        [self willChangeValueForKey:@"tabBarStyle"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:willChangeTabBarStyle:)]) {
            [self.delegate tabBar:self willChangeTabBarStyle:tabBarStyle];
        }
        
        if (tabBarStyle == CMTabBarStyleDefault) {
            self.backgroundImageView.alpha = 1.0f;
            self.useGlossEffect = NO;
            self.backgroundImageView.image = [self defaultBackgroundImage];
        } else if (tabBarStyle == CMTabBarStyleDefaultGloss) {
            self.backgroundImageView.alpha = 1.0f;
            self.useGlossEffect = YES;
            self.backgroundImageView.image = [self defaultBackgroundImage];
        } else if (tabBarStyle == CMTabBarStyleTranslucent) {
            self.backgroundImageView.alpha = 0.7f;
            self.useGlossEffect = NO;
            self.backgroundImageView.image = [self defaultBackgroundImage];
        } else if (tabBarStyle == CMTabBarStyleTranslucentGloss) {
            self.backgroundImageView.alpha = 0.7f;
            self.useGlossEffect = YES;
            self.backgroundImageView.image = [self defaultBackgroundImage];
        }
        
        _tabBarStyle = tabBarStyle;
        
        [self didChangeValueForKey:@"tabBarStyle"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didChangeTabBarStyle:)]) {
            [self.delegate tabBar:self didChangeTabBarStyle:tabBarStyle];
        }
    }
}


#pragma mark - Public


- (void)setItems:(NSArray*)tabBarItems animated:(BOOL)animated {
    // Add KVO for each UITabBarItem
    
    for (UIButton* button in self.buttons) {
        [button removeActionCompletionBlocksForControlEvents:UIControlEventTouchUpInside];
        [button removeFromSuperview];
    }
    
    NSMutableArray* newButtons = [NSMutableArray array];
    
    NSUInteger offset = 0;
    if (self.frame.size.width >= 768) {
        offset = self.frame.size.width / 4;
    }
    
    CGSize buttonSize = CGSizeMake((self.frame.size.width - offset * 2) / [tabBarItems count], self.frame.size.height);
    
    for (int i=0; i < [tabBarItems count]; i++) {
        UITabBarItem* tabBarItem = (UITabBarItem*)[tabBarItems objectAtIndex:i];
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonSize.width + offset, 0, buttonSize.width, buttonSize.height)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIImage* buttonImage = [CMTabBarUtils tabBarImage:tabBarItem.image size:buttonSize backgroundImage:nil];
        UIImage* buttonPressedImage = [CMTabBarUtils tabBarImage:tabBarItem.image size:buttonSize backgroundImage:[UIImage imageNamed:@"selectedBackground.png"]];
        
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setImage:buttonImage forState:UIControlStateDisabled];
        [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
        [button setImage:buttonPressedImage forState:UIControlStateSelected];
        [self addSubview:button];
        
        [button addActionCompletionBlock:^(id sender) {
            self.selectedIndex = i;
        } forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.selectedIndex) {
            [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateNormal];
            self.selectedImageView.center = button.center;
        }
        
        [newButtons addObject:button];
    }
    
    self.buttons = newButtons;
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
    if (self.useGlossEffect) {
        [[UIColor blackColor] set];
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, self.frame.size.height / 2, width, self.frame.size.height / 2));
    }
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage*)defaultSelectionIndicatorImage {
    return [UIImage imageNamed:@"glow.png"];
}


@end
