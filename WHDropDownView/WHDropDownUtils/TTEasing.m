//
//  TTEasing.m
//  FaveButton
//
//  Created by yitailong on 16/8/9.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "TTEasing.h"


 CGFloat TTTimingFunctionElasticOut (CGFloat _t, CGFloat b, CGFloat c, CGFloat d, CGFloat _a, CGFloat _p) {
    CGFloat  s = 0.0;
    CGFloat  t = _t;
    CGFloat  a = _a;
    CGFloat  p = _p;
    
    if (t==0) return b;  if ((t/=d)==1) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return (a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b);
}

CGFloat TTTTweenTimingFunctionElasticIn (CGFloat _t, CGFloat b, CGFloat c, CGFloat d, CGFloat _a, CGFloat _p)
{
    CGFloat  s = 0.0;
    CGFloat  t = _t;
    CGFloat  a = _a;
    CGFloat  p = _p;
    
    if (t==0) return b;  if ((t/=d)==1) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return -(a*pow(2,10*t) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}