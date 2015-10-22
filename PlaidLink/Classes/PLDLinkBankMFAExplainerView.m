//
//  PLDLinkBankMFAExplainerView.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAExplainerView.h"

static CGFloat const kPadding = 20.0;

@implementation PLDLinkBankMFAExplainerView {
  UIImageView *_explainerIcon;
  UILabel *_explainerLabel;
}

- (NSString *)explainerText {
  return _explainerLabel.text;
}

- (void)setExplainerText:(NSString *)explainerText {
  _explainerLabel.text = explainerText;
  [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _explainerIcon = [[UIImageView alloc] initWithImage:nil];
    [self addSubview:_explainerIcon];
    
    _explainerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_explainerLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [_explainerLabel sizeToFit];
  CGRect labelFrame = _explainerLabel.frame;
  labelFrame.origin.x = self.bounds.size.width - labelFrame.size.width - kPadding;
  labelFrame.origin.y = self.bounds.size.height / 2 - labelFrame.size.height / 2;
  _explainerLabel.frame = labelFrame;
}

@end
