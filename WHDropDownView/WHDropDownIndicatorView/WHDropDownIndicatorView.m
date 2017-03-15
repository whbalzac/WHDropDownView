//
//  WHDropDownIndicatorView.m
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHDropDownIndicatorView.h"
#import "WHDropDownIndicatorIconImageView.h"
#import "WHDropDownViewHeader.h"

@interface WHDropDownIndicatorView()

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) WHDropDownIndicatorIconImageView *iconImageView;

@end

@implementation WHDropDownIndicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(SCREEN_HEITH_LAYOUT(2));
        make.height.mas_equalTo(SCREEN_HEITH_LAYOUT(100));
    }];
    
    
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_width);
    }];
}

#pragma mark - private method

- (void)waggle
{
    CGFloat fromRotation = 0;
    CGFloat byRotation = 0.06;
    CGFloat toRotation = -0.06;
    
    CAKeyframeAnimation *circleTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    circleTransform.duration = 5;
    circleTransform.repeatCount  = 1;
    circleTransform.autoreverses = NO;
    
    circleTransform.values = @[
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, byRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, toRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, byRotation/2, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, toRotation/2, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               ];
    
    [self.layer addAnimation:circleTransform forKey:@"shakeAnimation"];
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    scaleY.values   = @[@1.0, @1.04, @1.01, @1.04, @1.01, @1.04, @1.02, @1.04, @1.01, @1.02, @1.0];
    scaleY.autoreverses = NO;
    scaleY.duration= 5;
    scaleY.repeatCount = 1;
    
    [self.layer addAnimation:scaleY forKey:@"scaleY"];
    
    [self.iconImageView flipsPicture];
}

- (void)blowup
{
    [self.iconImageView blowupWithRing];
    [self lineAppear];
}

- (void)lineAppear
{
    self.lineView.alpha = 0.0f;
    [UIView  animateWithDuration:0.35
                           delay:0.25
          usingSpringWithDamping:1
           initialSpringVelocity:10
                         options:0
                      animations:^{
                          
                          self.lineView.alpha = 1.0f;
                      }
                      completion:nil];
}

#pragma mark - getter

- (UIImageView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.image  = [[UIImage imageNamed:@"line.png"] pin_imageWithColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]];
    }
    
    return _lineView;
}

- (WHDropDownIndicatorIconImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[WHDropDownIndicatorIconImageView alloc] init];
    }
    
    return _iconImageView;
}


@end
