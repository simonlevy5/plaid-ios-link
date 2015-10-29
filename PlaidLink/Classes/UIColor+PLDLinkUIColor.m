//
//  PLDLinkUIColor+UIColor.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//

#import "UIColor+PLDLinkUIColor.h"

@implementation UIColor (PLDLinkUIColor)

- (UIColor *)lighterColorForBackground {
  return [self alterColorWithDeltaSaturation:-0.15 deltaBrightness:0.15];
}

- (UIColor *)lighterColorForText {
  return [self alterColorWithDeltaSaturation:-0.3 deltaBrightness:0.3];
}

- (UIColor *)lighterColorForLine {
  return [self alterColorWithDeltaSaturation:-0.1 deltaBrightness:0.1];
}

- (UIColor *)darkerColorForBackground {
  return [self alterColorWithDeltaSaturation:0.12 deltaBrightness:-0.12];
}

- (UIColor *)darkerColorForText {
  return [self alterColorWithDeltaSaturation:0.24 deltaBrightness:-0.24];
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
