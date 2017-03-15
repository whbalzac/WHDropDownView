//
//  WHDropDownContentCollectionViewCell.m
//  Example
//
//  Created by whbalzac on 3/15/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHDropDownContentCollectionViewCell.h"
#import "WHDropDownViewHeader.h"

@interface WHDropDownContentCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation WHDropDownContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    [self.contentView addSubview:self.titleLable];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
}

- (void)updateCellWithLabStr:(NSString *)labStr{
    
    self.titleLable.text = labStr;
}

#pragma mark - Getters
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont systemFontOfSize:14.f];
        [_titleLable sizeToFit];
    }
    return _titleLable;
}

@end
