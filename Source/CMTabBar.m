//
//  CMTabBar.m
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBar.h"


@interface CMTabBar()

@property (nonatomic, retain) NSArray*      buttons;
@property (nonatomic, retain) UIImageView*  backgroundImageView;

- (UIImage*)defaultBackgroundImage;
- (UIImage*)tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource;
- (UIImage*)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backImage;
- (UIImage*)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage;

@end


@implementation CMTabBar

@synthesize delegate, selectedItem, tintColor, backgroundImage, selectionIndicatorImage;
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


#pragma mark - Public


- (void)setItems:(NSArray*)tabBarItems animated:(BOOL)animated {
    // Add KVO for each UITabBarItem
    
    for (UIButton* button in self.buttons) {
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
        
        UIImage* buttonImage = [self tabBarImage:tabBarItem.image size:button.frame.size backgroundImage:nil];
        UIImage* buttonPressedImage = [self tabBarImage:tabBarItem.image size:buttonSize backgroundImage:[UIImage imageNamed:@"selectedBackground.png"]];
        
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
        [button setImage:buttonPressedImage forState:UIControlStateSelected];
        [self addSubview:button];
        
        [newButtons addObject:button];
    }
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

- (UIImage*)tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource {
    // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
    UIImage* backImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];
    
    // Convert the passed in image to a white backround image with a black fill
    UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
    
    // Create an image mask
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
                                             CGImageGetHeight(bwImage.CGImage),
                                             CGImageGetBitsPerComponent(bwImage.CGImage),
                                             CGImageGetBitsPerPixel(bwImage.CGImage),
                                             CGImageGetBytesPerRow(bwImage.CGImage),
                                             CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
    
    // Using the mask create a new image
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backImage.CGImage, imageMask);
    
    UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGImageRelease(imageMask);
    CGImageRelease(tabBarImageRef);
    
    // Create a new context with the right size
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    // Draw the new tab bar image at the center
    [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage*)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backImage {
    // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backImage) {
        // Draw the background image centered
        [backImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backImage.CGImage)) / 2, CGImageGetWidth(backImage.CGImage), CGImageGetHeight(backImage.CGImage))];
    } else {
        [[UIColor colorWithWhite:0.8 alpha:1.0] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }
    
    UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalBackgroundImage;
}

- (UIImage*)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage {
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color to black: R:0 G:0 B:0 alpha:1
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    // Fill with black
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}


@end
