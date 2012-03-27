//
//  CMTabBarUtils.m
//
//  Created by Constantine Mureev on 15.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBarUtils.h"

@implementation CMTabBarUtils

+ (UIImage*)tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource {
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
    [tabBarImage drawInRect:CGRectMake(round((targetSize.width/2.0) - (startImage.size.width/2.0)), round((targetSize.height/2.0) - (startImage.size.height/2.0)), startImage.size.width, startImage.size.height)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage*)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backImage {
    // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backImage) {
        // Draw the background image centered
        [backImage drawInRect:CGRectMake(round((targetSize.width - CGImageGetWidth(backImage.CGImage)) / 2), round((targetSize.height - CGImageGetHeight(backImage.CGImage))) / 2, CGImageGetWidth(backImage.CGImage), CGImageGetHeight(backImage.CGImage))];
    } else {
        [[UIColor colorWithWhite:0.8 alpha:1.0] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }
    
    UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalBackgroundImage;
}

+ (UIImage*)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage {
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
