//
//  WHDropDownIndicatorIconImageView.h
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHDropDownIndicatorIconImageView : UIImageView

@property (nonatomic, strong) NSArray<NSString *> *imageNameArray;

- (void)flipsPicture;

- (void)blowupWithRing;

@end
