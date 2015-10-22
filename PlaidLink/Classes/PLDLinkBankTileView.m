//
//  PLDLinkBankTileView.m
//  plaid
//
//  Created by Andres Ugarte on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankTileView.h"

#import "PLDInstitution.h"

@implementation PLDLinkBankTileView {
  UIImageView *_logo;
  UILabel *_label;
}

- (void)setInstitution:(PLDInstitution *)institution {
  _institution = institution;
  _label.text = _institution.name;
  [_label sizeToFit];
  [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6.0f;

    _logo = [[UIImageView alloc] initWithImage:nil];
    [self addSubview:_logo];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self addSubview:_label];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  _logo.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
