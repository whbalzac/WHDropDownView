//
//  WHDropDownContentView.m
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHDropDownContentView.h"
#import "WHDropDownContentCollectionViewCell.h"
#import "Masonry.h"
#import "WHDropDownViewHeader.h"

@interface WHDropDownContentView()<UICollectionViewDelegate, UICollectionViewDataSource, CAAnimationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UIView *footView;

@property (nonatomic, assign) CGFloat startDragY;
@property (nonatomic, assign) CGFloat startCollectionViewDragY;
@property (nonatomic, assign) CGFloat startScrollY;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) NSMutableArray<NSString*>* newsArray;

@end

@implementation WHDropDownContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startDragY = 0.f;
        self.startCollectionViewDragY = 0.f;
        self.startScrollY = 0.f;
        self.newsArray = [NSMutableArray array];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor grayColor];
    
    [self addSubview:self.topView];
    [self addSubview:self.contentCollectionView];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.backBtn];
    [self addSubview:self.footView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(SCREEN_HEITH_LAYOUT(200.f));
    }];
    
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH-SCREEN_HEITH_LAYOUT(30.f));
        make.height.mas_equalTo(SCREEN_HEIGHT-ContentViewHeight-FootViewHeight);
        make.bottom.equalTo(self.headerView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ContentViewHeight);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).with.offset(-SCREEN_HEITH_LAYOUT(15.f));
        make.top.equalTo(self.headerView.mas_top).with.offset(SCREEN_HEITH_LAYOUT(40.f));
        make.width.mas_equalTo(SCREEN_HEITH_LAYOUT(80.f));
        make.height.mas_equalTo(SCREEN_HEITH_LAYOUT(40.f));
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(FootViewHeight);
    }];
    
    [self loadData];
}

- (void)backView
{
    if ([self.delegate respondsToSelector:@selector(flyBack)]) {
        [self.delegate flyBack];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    [self.contentCollectionView.layer removeAnimationForKey:@"animateTransformSmall"];
}

- (void)changeViewLevelWithOffsetY:(CGFloat)offsetY
{
    if (offsetY == 0) {
        [self bringSubviewToFront:self.headerView];
        [self addSmallAnimation];
        self.footView.alpha = 0.f;
        [self.contentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(SCREEN_HEIGHT-ContentViewHeight-FootViewHeight);
        }];
    }else if (offsetY == SCREEN_HEIGHT-ContentViewHeight-FootViewHeight){
        
        [self bringSubviewToFront:self.contentCollectionView];
        [self bringSubviewToFront:self.footView];
        
        CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        theAnimation.duration=0.2;
        theAnimation.removedOnCompletion = NO;
        theAnimation.autoreverses = NO;
        theAnimation.fromValue = [NSNumber numberWithFloat:1];
        theAnimation.toValue = [NSNumber numberWithFloat:1.03];
        theAnimation.repeatCount = 1;
        theAnimation.fillMode = kCAFillModeForwards;
        theAnimation.delegate = self;
        [self.contentCollectionView.layer addAnimation:theAnimation forKey:@"animateTransformBig"];
        
        self.footView.alpha = 1.f;
    }
}

- (void)updateUIWithOffsetY:(CGFloat)offsetY
{
    
    if (offsetY < 0) {
        return;
    }
    
    [self.contentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).with.offset(offsetY);
    }];
    
    self.footView.alpha = (offsetY)/SCREEN_HEIGHT;
    
    if (self.contentCollectionView.isScrollEnabled && self.newsArray.count > 0) {
        [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        
        self.contentCollectionView.scrollEnabled = NO;
        [self setPanGesture];
    }
}

- (void)addSmallAnimation
{
    CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration=0.2;
    theAnimation.removedOnCompletion = NO;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.03];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    theAnimation.repeatCount = 1;
    theAnimation.fillMode = kCAFillModeForwards;
    //            theAnimation.delegate = self;
    [self.contentCollectionView.layer addAnimation:theAnimation forKey:@"animateTransformSmall"];
}

- (void)handleFootView:(UIPanGestureRecognizer*)paramSender
{
    CGPoint location = [paramSender locationInView:paramSender.view.superview];
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        self.startDragY = location.y;
    }
    
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        if (location.y<FootViewHeight/2.f || location.y>SCREEN_HEIGHT+FootViewHeight/2.f) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(flyToSomePositionWithOffsetY:)]) {
            [self.delegate flyToSomePositionWithOffsetY:location.y+FootViewHeight/2.f];
        }
        
        [self updateUIWithOffsetY:(location.y - ContentViewHeight - FootViewHeight/2.f)];
        
        self.footView.alpha = (location.y - ContentViewHeight - FootViewHeight/2.f)/SCREEN_HEIGHT;
        
        if (![self.contentCollectionView.layer animationForKey:@"animateTransformSmall"]) {
            [self addSmallAnimation];
        }
        
    }else if (paramSender.state == UIGestureRecognizerStateEnded){
        
        if (location.y > self.startDragY) {
            if ([self.delegate respondsToSelector:@selector(flyDown)]) {
                [self.delegate flyDown];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(flyBack)]) {
                [self.delegate flyBack];
            }
        }
    }
}

- (void)handleCollectionView:(UIPanGestureRecognizer*)paramSender
{
    
    CGPoint location = [paramSender locationInView:paramSender.view.superview];
    CGPoint point = [paramSender.view convertPoint:CGPointMake(0, 0) fromView:paramSender.view.superview];
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        self.startCollectionViewDragY = location.y;
    }else if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        
        if (self.startCollectionViewDragY < location.y) {
            return;
        }
        
        if (self.startCollectionViewDragY - location.y > 150.f) {
            return;
        }
        
        [self.contentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(SCREEN_HEIGHT-ContentViewHeight-FootViewHeight + (self.startCollectionViewDragY - location.y));
        }];
        
    }else if (paramSender.state == UIGestureRecognizerStateEnded){
        
        if (location.y > self.startCollectionViewDragY){
            return;
        }
        
        if (point.y >= -ContentViewHeight && point.y < -ContentViewHeight*(3.f/4.f)) {
            [self dragDown];
        }else if (point.y <= -30 && point.y >= -ContentViewHeight*(3.f/4.f)){
            [self dragUpWithScrollGap:(self.startCollectionViewDragY - location.y)];
        }
    }
}

- (void)tapToFlyBack
{
    if ([self.delegate respondsToSelector:@selector(flyBack)]) {
        [self.delegate flyBack];
    }
}


- (void)dragDown
{
    
    [self.contentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SCREEN_HEIGHT-ContentViewHeight-FootViewHeight);
    }];
    
    [UIView transitionWithView:self.contentCollectionView duration:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self setPanGesture];
            self.contentCollectionView.scrollEnabled = NO;
        }
    }];
    
}

- (void)dragUpWithScrollGap:(CGFloat)scrollGap
{
    [self.contentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SCREEN_HEIGHT-FootViewHeight-30.f);
    }];
    
    [UIView transitionWithView:self.contentCollectionView duration:.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removePanGesture];
            self.contentCollectionView.scrollEnabled = YES;
            
            NSUInteger theLastCellIndex = 0;
            for (UICollectionViewCell *cell in self.contentCollectionView.visibleCells) {
                if (theLastCellIndex < cell.tag) {
                    theLastCellIndex = cell.tag;
                }
            }
            if (scrollGap > 100.f && theLastCellIndex > 0 && theLastCellIndex < self.newsArray.count) {
                NSInteger scrollCount = (int)((scrollGap - 100.f)/40) + 1;
                if (theLastCellIndex + scrollCount < self.newsArray.count) {
                    //                    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:scrollCount inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                }
            }
        }
    }];
}

- (void)setPanGesture
{
    [self removePanGesture];
    
    [self.contentCollectionView addGestureRecognizer:self.panGesture];
}

- (void)removePanGesture
{
    if (self.panGesture.view) {
        [self.contentCollectionView removeGestureRecognizer:self.panGesture];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    self.startScrollY = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        
        self.contentCollectionView.scrollEnabled = NO;
        
        [self dragDown];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH-SCREEN_HEITH_LAYOUT(30.f), SCREEN_HEITH_LAYOUT(100.f));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHDropDownContentCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WHDropDownContentCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.item %2 ==0) {
        cell.contentView.backgroundColor = [UIColor cyanColor];
    }else{
        cell.contentView.backgroundColor = [UIColor purpleColor];
    }
    cell.tag = indexPath.item;
    
    
    if (indexPath.row >= self.newsArray.count) {
        return nil;
    }
    
    [cell updateCellWithLabStr:self.newsArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.newsArray.count) {
        return;
    }
    
    NSLog(@"Your detail ViewController should be presented.");
}


#pragma mark - private

- (void)loadData
{
    [self.newsArray addObject:@"0"];
    [self.newsArray addObject:@"1"];
    [self.newsArray addObject:@"2"];
    [self.newsArray addObject:@"2"];
    [self.newsArray addObject:@"3"];
    [self.newsArray addObject:@"4"];
    [self.newsArray addObject:@"5"];
    [self.newsArray addObject:@"6"];
    [self.newsArray addObject:@"7"];
    [self.newsArray addObject:@"8"];
    [self.newsArray addObject:@"9"];
}

#pragma mark - Getters
- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor yellowColor];
    }
    return _topView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor yellowColor];
    }
    return _headerView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setTitle:@"Back" forState:UIControlStateNormal];
        _backBtn.backgroundColor = [UIColor redColor];
        [_backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [UIView new];
        _footView.backgroundColor = [UIColor orangeColor];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFootView:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        [_footView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFlyBack)];
        [_footView addGestureRecognizer:tapGesture];
    }
    return _footView;
}

- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *contentFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        contentFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        contentFlowLayout.minimumLineSpacing = 0.f;
        contentFlowLayout.minimumInteritemSpacing = 0.f;
        
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:contentFlowLayout];
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.alwaysBounceVertical = NO;
        _contentCollectionView.alwaysBounceHorizontal = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.scrollEnabled = NO;
        [_contentCollectionView registerClass:[WHDropDownContentCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WHDropDownContentCollectionViewCell class])];
        
        [_contentCollectionView addGestureRecognizer:self.panGesture];
        
    }
    return _contentCollectionView;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCollectionView:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
    }
    return _panGesture;
}

@end
