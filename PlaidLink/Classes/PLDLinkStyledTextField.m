//
//  PLDLinkStyledTextField.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkStyledTextField.h"

#import "UIColor+PLDLinkUIColor.h"

@implementation PLDLinkStyledTextField {
  UIColor *_containerColor;
}

- (instancetype)initWithFrame:(CGRect)frame
                    tintColor:(UIColor *)tintColor
                  placeholder:(NSString *)placeholder {
  if (self = [super initWithFrame:frame]) {
    _containerColor = tintColor;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    self.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder
        attributes:@{NSForegroundColorAttributeName:[tintColor lighterColorForText]}];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat lineHeight = 1.0;
  CGColorRef lineColor = [_containerColor lighterColorForLine].CGColor;
  CGContextSetFillColorWithColor(context, lineColor);
  CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - lineHeight);
  CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - lineHeight);
  CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
  CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - lineHeight);
  CGContextFillPath(context);
}

- (void)setPlaceholder:(NSString *)placeholder {
  self.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder
      attributes:@{NSForegroundColorAttributeName:[_containerColor lighterColorForText]}];
}

@end
