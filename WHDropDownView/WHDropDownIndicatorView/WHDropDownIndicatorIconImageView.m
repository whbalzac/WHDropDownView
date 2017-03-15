//
//  WHDropDownIndicatorIconImageView.m
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHDropDownIndicatorIconImageView.h"
#import "WHDropDownViewHeader.h"

@interface WHDropDownIndicatorIconImageView()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSString *lastImageName;

@end

@implementation WHDropDownIndicatorIconImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(SCREEN_HEITH_LAYOUT(6));
        make.height.mas_equalTo(self.iconImageView.mas_width);
    }];
}

#pragma mark - private method
- (void)flipsPicture
{
    NSString *lastOne = self.lastImageName;
    self.lastImageName = [NSString stringWithFormat:@"%zd",arc4random() % 4];
    NSString *newOne = self.lastImageName;
    
    [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        
        self.iconImageView.image = [UIImage imageNamed:newOne];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
            
            self.iconImageView.image = [UIImage imageNamed:lastOne];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5f delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
                
                self.iconImageView.image = [UIImage imageNamed:newOne];
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }];
}

-(void)blowupWithRing
{
    [self popOutsideWithDuration];
    
    CGFloat radius  = self.iconImageView.bounds.size.height*1.3/2; // ring radius
    CGFloat igniteFromRadius = radius*0.4;
    CGFloat igniteToRadius   = radius*0.7;
    
    NSArray *sparks = [self createSparks:igniteFromRadius];
    for (TTSpark *spark in sparks) {
        [spark animateIgniteShow:igniteToRadius duration:1.0 delay:0.05];
        [spark animateIgniteHide:0.8 delay:0.2];
    }
}

// blowup
- (void)blowup
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = [self generateTweenValues:0 to:1 duration:1];
    scaleAnimation.duration = 1;
    scaleAnimation.beginTime = CACurrentMediaTime();
    [self.layer addAnimation:scaleAnimation forKey:nil];
    
}

- (void) popOutsideWithDuration
{
    self.image = [UIImage imageNamed:@"sparkle.png"];
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView  animateWithDuration:0.25
                           delay:0
          usingSpringWithDamping:1
           initialSpringVelocity:10
                         options:0
                      animations:^{
                          
                          self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                      }
                      completion:^(BOOL finished) {
                          self.image = nil;
                      }];
    
    self.iconImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView  animateWithDuration:0.35
                           delay:0.25
          usingSpringWithDamping:1
           initialSpringVelocity:10
                         options:0
                      animations:^{
                          
                          self.iconImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                      }
                      completion:nil];
}

- (NSArray *)generateTweenValues:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration
{
    NSMutableArray *values = [@[] mutableCopy];
    CGFloat fps = 60.0;
    CGFloat tpf = duration/fps;
    CGFloat c = to-from;
    CGFloat d = duration;
    CGFloat t = 0.0;
    
    while (t < d) {
        CGFloat scale = TTTimingFunctionElasticOut(t, from, c, d, c+0.001, 0.39988);
        [values addObject:@(scale)];
        t += tpf;
    }
    return values;
}

//sparks
- (NSArray *)createSparks:(CGFloat)radius
{
    NSMutableArray *sparks = [@[] mutableCopy];
    CGFloat step = 360.0/7;
    CGFloat base = self.bounds.size.width;
    DotRadius dotRadius = {base*0.08, base*0.06};
    CGFloat offset = 10.0;
    
    
    for (NSInteger index=0; index<=7; index++) {
        CGFloat theta  = step * index + offset;
        
        NSArray *colors = [self dotColorsAtIndex:index];
        
        TTSpark *spark = [TTSpark createSpark:self.iconImageView radius:radius firstColor:colors.firstObject secondColor:colors.lastObject angle:theta dotRadius:dotRadius];
        [sparks addObject:spark];
    }
    
    return sparks;
}

//dots
- (NSArray *)dotColorsAtIndex:(NSInteger)index
{
    return @[[UIColor colorWithRed:152/255.0 green:219/255.0 blue:236/255.0 alpha:1], [UIColor colorWithRed:247/255.0 green:188/255.0 blue:48/255.0 alpha:1]];
}


#pragma mark - getter
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        self.lastImageName = [NSString stringWithFormat:@"%zd",arc4random() % 4];
        _iconImageView.image = [UIImage imageNamed:self.lastImageName];
    }
    return _iconImageView;
}

@end
