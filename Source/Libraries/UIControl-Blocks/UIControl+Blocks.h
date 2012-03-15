//
//  UIControl+Blocks.h
//
//  Created by Dave Peck on 1/2/12
//
//  Adapted From:
//  http://stackoverflow.com/questions/4581782/can-i-pass-a-block-as-a-selector-with-objective-c
//

#import <UIKit/UIKit.h>

@interface UIControl (Blocks)

- (void)addActionCompletionBlock:(void(^)(id sender))actionCompletionBlock forControlEvents:(UIControlEvents)controlEvents; 

- (void)removeActionCompletionBlocksForControlEvents:(UIControlEvents)controlEvents;

@end

