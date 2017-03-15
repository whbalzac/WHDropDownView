//
//  WHDropDownView.m
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHDropDownView.h"
#import "WHDropDownIndicatorView.h"
#import "WHDropDownContentView.h"
#import "WHDropDownViewHeader.h"

@interface WHDropDownView()<WHDropDownContentViewDelegate>

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) WHDropDownIndicatorView *indicatorView;
@property (nonatomic, strong) WHDropDownContentView *contentView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WHDropDownView

+ (WHDropDownView *)sharedInstance
{
    static WHDropDownView *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WHDropDownView alloc] init];
    });
    
    return _sharedInstance;
}

- (void)showDropDownViewOn:(UIView *)bottomView;
{
    self.bottomView = bottomView;
    
    [self configureView];
}

- (void)configureView
{
    [self.bottomView addSubview:self];
    self.frame = self.bottomView.bounds;
    
    [self addSubview:self.contentView];
    [self addSubview:self.indicatorView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(ContentViewHeight);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-40);
        make.centerY.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(SCREEN_HEITH_LAYOUT(60));
        make.height.mas_equalTo(SCREEN_HEITH_LAYOUT(260));
    }];
    
    [self boomup];
    [self startLazyMode];
}

#pragma mark - private

- (void)boomup
{
    [self.indicatorView blowup];
}

- (void)startLazyMode{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15.f target:self selector:@selector(dragAway) userInfo:nil repeats:YES];
    }
}

- (void)stopLazyMode{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dragAway{
    [self.indicatorView waggle];
}

#pragma mark - FloatViewDelegate

- (void)flyBack
{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(ContentViewHeight);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.contentView updateUIWithOffsetY:0.f];
    
    [UIView animateWithDuration:.5f animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.indicatorView waggle];
        [self.contentView changeViewLevelWithOffsetY:0.f];
        [self startLazyMode];
    }];
}

- (void)flyDown
{
    [self clickImageEvent];
}

- (void)flyToSomePositionWithOffsetY:(CGFloat)offsetY
{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(offsetY);
    }];
}

#pragma mark - action
- (void)clickImageEvent
{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [self.contentView updateUIWithOffsetY:SCREEN_HEIGHT-ContentViewHeight-FootViewHeight];
    
    [UIView animateWithDuration:.5f animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.contentView changeViewLevelWithOffsetY:SCREEN_HEIGHT-ContentViewHeight-FootViewHeight];
        [self stopLazyMode];
    }];
}

- (void)handlePanGestures:(UIPanGestureRecognizer*)paramSender
{
    [self stopLazyMode];
    CGPoint location = [paramSender locationInView:paramSender.view.superview];
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        if (location.y < FlyViewHeight/2.f || location.y>SCREEN_HEIGHT+FlyViewHeight/2.f) {
            return;
        }
        
        if (location.y <= 260.f) {
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bottomView);
                make.height.mas_equalTo(ContentViewHeight);
                make.bottom.equalTo(self.bottomView.mas_top).with.offset(location.y-FlyViewHeight/2.f);
            }];
        }else{
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.bottomView);
                make.height.mas_equalTo(location.y - FlyViewHeight/2.f);
            }];
        }
        [self.contentView updateUIWithOffsetY:(location.y - FlyViewHeight/2.f - ContentViewHeight - FootViewHeight)];
    }else if (paramSender.state == UIGestureRecognizerStateEnded){
        if (location.y > (SCREEN_HEIGHT+FlyViewHeight/2.f)/4.f) {
            [self clickImageEvent];
        }else {
            [self flyBack];
        }
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - getter
- (WHDropDownIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[WHDropDownIndicatorView alloc] init];
        [_indicatorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageEvent)]];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        [_indicatorView addGestureRecognizer:panGesture];
    }
    return _indicatorView;
}

-(WHDropDownContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[WHDropDownContentView alloc] init];;
        _contentView.delegate = self;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}


@end
