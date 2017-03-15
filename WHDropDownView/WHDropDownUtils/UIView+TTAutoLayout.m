//
//  UIView+TTAutoLayout.m
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "UIView+TTAutoLayout.h"

@implementation UIView (TTAutoLayout)

- (NSLayoutConstraint *)TTConstraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d ", self, attribute];
    NSArray *predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
   
    if (predicatedArray.count > 0) {
        return predicatedArray.firstObject;
    }
    
    return nil;
}

@end
