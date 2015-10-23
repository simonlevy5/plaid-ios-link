//
//  PLDLinkUIColor+UIColor.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "UIColor+PLDLinkUIColor.h"

@implementation UIColor (PLDLinkUIColor)

- (UIColor *)lighterColorForBackground {
  return [self alterColorWithDeltaSaturation:-0.15 deltaBrightness:0.15];
}

- (UIColor *)lighterColorForText {
  return [self alterColorWithDeltaSaturation:-0.3 deltaBrightness:0.3];
}

- (UIColor *)darkerColorForBackground {
  return [self alterColorWithDeltaSaturation:0.15 deltaBrightness:-0.15];
}

- (UIColor *)darkerColorForText {
  return [self alterColorWithDeltaSaturation:0.3 deltaBrightness:-0.3];
}

#pragma mark Private

- (UIColor *)alterColorWithDeltaSaturation:(CGFloat)saturation deltaBrightness:(CGFloat)brightness {
  CGFloat h,s,b,a;
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    return [UIColor colorWithHue:h
                      saturation:MAX(s + saturation, 0.0)
                      brightness:MIN(b + brightness, 1.0)
                           alpha:a];
  }
  return nil;
}

@end
