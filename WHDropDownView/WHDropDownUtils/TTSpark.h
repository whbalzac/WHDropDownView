//
//  TTSpark.h
//  FaveButton
//
//  Created by yitailong on 16/8/9.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct TTDotRadius {
    CGFloat first;
    CGFloat second;
} DotRadius;

@interface TTSpark : UIView

- (void)animateIgniteShow:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;
- (void)animateIgniteHide:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

+ (TTSpark *)createSpark:(UIView *)faveButton radius:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle dotRadius:(DotRadius )dotRadius;

@end
