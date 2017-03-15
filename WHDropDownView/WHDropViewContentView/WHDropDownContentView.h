//
//  WHDropDownContentView.h
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHDropDownContentViewDelegate <NSObject>

- (void)flyBack;

- (void)flyDown;

- (void)flyToSomePositionWithOffsetY:(CGFloat)offsetY;

@end

@interface WHDropDownContentView : UIView

@property (nonatomic, weak) id<WHDropDownContentViewDelegate> delegate;

- (void)updateUIWithOffsetY:(CGFloat)offsetY;

- (void)changeViewLevelWithOffsetY:(CGFloat)offsetY;


@end
