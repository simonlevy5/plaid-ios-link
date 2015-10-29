//
//  PLDLinkBankMFAExplainerView.m
//  PlaidLink
//
//  Created by Simon Levy on 10/20/15.
//

#import "PLDLinkBankMFAExplainerView.h"

#import "UIColor+PLDLinkUIColor.h"

@implementation PLDLinkBankMFAExplainerView {
  UILabel *_explainerLabel;
}

- (NSString *)explainerText {
  return _explainerLabel.text;
}

- (void)setExplainerText:(NSString *)explainerText {
  _explainerLabel.text = explainerText;
  [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    self.tintColor = tintColor;
    _explainerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_explainerLabel setTextAlignment:NSTextAlignmentCenter];
    [_explainerLabel setFont:[UIFont systemFontOfSize:11]];
    [_explainerLabel setTextColor:[UIColor whiteColor]];
    [_explainerLabel setBackgroundColor:[self.tintColor darkerColorForBackground]];
    [self addSubview:_explainerLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _explainerLabel.frame = self.bounds;
}

@end
