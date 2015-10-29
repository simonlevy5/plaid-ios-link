//
//  PLDLinkStyledTextField.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//

#import "PLDLinkStyledTextField.h"

#import "UIColor+PLDLinkUIColor.h"

static CGFloat const kHorizontalInset = 2.0;
static CGFloat const kLineHeight = 1.0;

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
  CGColorRef lineColor = [_containerColor lighterColorForLine].CGColor;
  CGContextSetFillColorWithColor(context, lineColor);
  CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - kLineHeight);
  CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - kLineHeight);
  CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
  CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - kLineHeight);
  CGContextFillPath(context);
}

- (void)setPlaceholder:(NSString *)placeholder {
  self.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder
      attributes:@{NSForegroundColorAttributeName:[_containerColor lighterColorForText]}];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset([super textRectForBounds:bounds], kHorizontalInset, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset([super editingRectForBounds:bounds], kHorizontalInset, 0);
}

@end
