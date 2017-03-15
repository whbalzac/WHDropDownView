//
//  WHDropDownViewHeader.h
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#ifndef WHDropDownViewHeader_h
#define WHDropDownViewHeader_h

#import "Masonry.h"
#import "UIImage+Overlay.h"
#import "TTEasing.h"
#import "TTSpark.h"
#import "UIView+TTAutoLayout.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SCREEN_WIDTH_LAYOUT(x) SCREEN_WIDTH / 375.0 * (x)
#define SCREEN_HEITH_LAYOUT(x) SCREEN_HEIGHT / 667.0 * (x)

#define ContentViewHeight    SCREEN_HEITH_LAYOUT(180.f)
#define FootViewHeight      SCREEN_HEITH_LAYOUT(40.f)
#define FlyViewHeight       SCREEN_HEITH_LAYOUT(160.f)

#endif /* WHDropDownViewHeader_h */
