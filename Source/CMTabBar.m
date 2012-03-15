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

@property (nonatomic, retain) NSArray*      buttons;
@property (nonatomic, retain) UIImageView*  backgroundImageView;

- (UIImage*)defaultBackgroundImage;

@end


@implementation CMTabBar

@synthesize delegate, selectedIndex=_selectedIndex, tintColor, backgroundImage, selectionIndicatorImage;
@synthesize buttons, backgroundImageView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex != selectedIndex && selectedIndex < [self.buttons count]) {
        // check only for first selection
        if (_selectedIndex < [self.buttons count]) {
            [self willChangeValueForKey:@"selectedIndex"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:willSelectItemAtIndex:)]) {
                [self.delegate tabBar:self willSelectItemAtIndex:_selectedIndex];
            }
            
            UIButton* oldButton = [self.buttons objectAtIndex:_selectedIndex];
            [oldButton setImage:[oldButton imageForState:UIControlStateDisabled] forState:UIControlStateNormal];
        }
        
        UIButton* newButton = [self.buttons objectAtIndex:selectedIndex];
        [newButton setImage:[newButton imageForState:UIControlStateSelected] forState:UIControlStateNormal];
        
        _selectedIndex = selectedIndex;
        
        [self didChangeValueForKey:@"selectedIndex"];        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
            [self.delegate tabBar:self didSelectItemAtIndex:_selectedIndex];
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
        
        UIImage* buttonImage = [CMTabBarUtils tabBarImage:tabBarItem.image size:button.frame.size backgroundImage:nil];
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
